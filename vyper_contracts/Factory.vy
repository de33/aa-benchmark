ACCOUNT_IMPLEMENTATION: immutable(address)
INITCODE_HASH: immutable(bytes32)

@external
def __init__(account_implementation: address):
    ACCOUNT_IMPLEMENTATION = account_implementation
    INITCODE_HASH = self.eip1167_initcode_hash()

@payable
@external
def create_account(owner: address, salt: uint256) -> address:
    addr: address = self._get_address(owner, salt)
    success: bool = True
    response: Bytes[32] = b""
    success, response = raw_call(addr, method_id("entryPoint()"), max_outsize=20, is_static_call=True, revert_on_failure=False)
    if response != b"":
        return addr
    proxy: address = create_minimal_proxy_to(ACCOUNT_IMPLEMENTATION, salt=keccak256(_abi_encode(owner, salt)))
    response = raw_call(proxy, concat(method_id("initialize(address,address)"), _abi_encode(ACCOUNT_IMPLEMENTATION, owner)), max_outsize=32)
    return proxy


@view
@internal
def _get_address(owner: address, salt: uint256) -> address:
    salt_hash: bytes32 = keccak256(_abi_encode(owner, salt))    
    proxy: address = self.address_from_bytes(keccak256(concat(b"\xff", convert(self, bytes20), salt_hash, INITCODE_HASH)))
    return proxy

@view
@external
def get_address(owner: address, salt: uint256) -> address:
    return self._get_address(owner, salt) 

@view 
@internal
def address_from_bytes(b: bytes32) -> address:
    return convert(slice(b, 12, 20), address)

@view 
@internal
def eip1167_initcode_hash() -> bytes32:
    pre: Bytes[19] = b"\x60\x2d\x3d\x81\x60\x09\x3d\x39\xf3\x36\x3d\x3d\x37\x3d\x3d\x3d\x36\x3d\x73"
    post: Bytes[15] = b"\x5a\xf4\x3d\x82\x80\x3e\x90\x3d\x91\x60\x2b\x57\xfd\x5b\xf3"
    return keccak256(concat(pre, convert(ACCOUNT_IMPLEMENTATION, bytes20), post))

