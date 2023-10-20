interface IVyperFactory {
    function account_implementation() external view returns (address);

    function create_account(
        address owner,
        uint256 salt
    ) external returns (address);

    function get_address(
        address owner,
        uint256 salt
    ) external view returns (address);

    function get_bytecode() external view returns (bytes32);

    event ProxyCreated(address indexed proxy);
}
