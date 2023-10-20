interface IVyperAccount {
    function upgradeImplementation(address implementation) external;

    function changeAdmin(address admin) external;

    function execute(address to, uint256 _value, bytes calldata data) external;

    function validateUserOp(
        UserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external returns (uint256);

    function getNonce() external view returns (uint256);

    function implementation() external view returns (address);

    function entryPoint() external view returns (address);

    function admin() external view returns (address);

    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }

    event UpgradeImplementation(address indexed implementation);
    event ChangeAdmin(address indexed admin);
}
