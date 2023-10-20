# The signing functions in this file are taken from pcaversaccio/snekmate
implementation: public(address)
admin: public(address)
factory: public(address)

# Constants
ENTRY_POINT: constant(address) = 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789
_MALLEABILITY_THRESHOLD: constant(bytes32) = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
_SIGNATURE_INCREMENT: constant(bytes32) = 0X7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

# Structs
struct UserOperation:
    sender: address
    nonce: uint256
    initCode: Bytes[104]
    callData: Bytes[1024]
    callGasLimit: uint256
    verificationGasLimit: uint256
    preVerificationGas: uint256
    maxFeePerGas: uint256
    maxPriorityFeePerGas: uint256
    paymasterAndData: Bytes[1024]
    signature: Bytes[65]


# Events
event UpgradeImplementation:
    implementation: indexed(address)

event ChangeAdmin:
    admin: indexed(address)

# Initialization
@external
def initialize(implementation: address, admin: address):
    assert self.implementation == empty(address)
    self.implementation = self
    self.factory = msg.sender
    self.admin = admin

# Admin functions
@external
def upgradeImplementation(implementation: address):
    self._checkAdmin()
    self.implementation = implementation
    log UpgradeImplementation(implementation)

@external
def changeAdmin(admin: address):
    self._checkAdmin()
    self.admin = admin
    log ChangeAdmin(admin)

# Transaction execution
@payable
@external
def execute(to: address, _value: uint256, data: Bytes[10000]):
    self._checkAdminOrEntryPoint()
    raw_call(to, data, value=_value)

# Signature validation
@internal
def _validateSignature(userOp: UserOperation, userOpHash: bytes32) -> uint256:
    hash: bytes32 = self.to_eth_signed_message_hash(userOpHash)
    if (self.admin != self.recover_sig(hash, userOp.signature)):
        return 1
    return 0

@external
def validateUserOp(userOp: UserOperation, userOpHash: bytes32, missingAccountFunds: uint256) -> uint256:
    self._checkEntryPoint()
    validationData: uint256 = self._validateSignature(userOp, userOpHash)
    self._payPrefund(missingAccountFunds)
    return validationData

@external
@view
def entryPoint()-> address:
    return ENTRY_POINT

@internal
def _checkAdmin():
    assert msg.sender == self.admin, "Unauthorized"

@internal
def _checkEntryPoint():
    assert msg.sender == ENTRY_POINT, "Unauthorized"

@internal
def _checkAdminOrEntryPoint():
    assert msg.sender == self.admin or msg.sender == ENTRY_POINT, "Unauthorized"

@internal
def _payPrefund(missingAccountFunds: uint256):
    if (missingAccountFunds > 0):
        raw_call(msg.sender, b"", value=missingAccountFunds, gas=max_value(uint256))

@internal
@pure
def to_eth_signed_message_hash(hash: bytes32) -> bytes32:
    return keccak256(concat(b"\x19Ethereum Signed Message:\n32", hash))

@internal
@pure
def recover_sig(hash: bytes32, signature: Bytes[65]) -> address:
    # 65-byte case: r,s,v standard signature.
    if (len(signature) == 65):
        r: uint256 = extract32(signature, 0, output_type=uint256)
        s: uint256 = extract32(signature, 32, output_type=uint256)
        v: uint256 = convert(slice(signature, 64, 1), uint256)
        return self._try_recover_vrs(hash, v, r, s)
    # 64-byte case: r,vs signature; see: https://eips.ethereum.org/EIPS/eip-2098.
    elif (len(signature) == 64):
        r: uint256 = extract32(signature, 0, output_type=uint256)
        vs: uint256 = extract32(signature, 32, output_type=uint256)
        return self._try_recover_r_vs(hash, r, vs)
    else:
        return empty(address)

@internal
@pure
def _try_recover_r_vs(hash: bytes32, r: uint256, vs: uint256) -> address:
    s: uint256 = vs & convert(_SIGNATURE_INCREMENT, uint256)
    # We do not check for an overflow here since the shift operation
    # `shift(vs, -255)` results essentially in a uint8 type (0 or 1)
    # and we use uint256 as result type.
    v: uint256 = unsafe_add(vs >> 255, 27)
    return self._try_recover_vrs(hash, v, r, s)


@internal
@pure
def _try_recover_vrs(hash: bytes32, v: uint256, r: uint256, s: uint256) -> address:
    if (s > convert(_MALLEABILITY_THRESHOLD, uint256)):
        raise "ECDSA: invalid signature 's' value"

    signer: address = ecrecover(hash, v, r, s)
    if (signer == empty(address)):
        raise "ECDSA: invalid signature"
    
    return signer

 
@external
@payable
def __default__():
    pass