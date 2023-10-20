import "snekmate/utils/VyperDeployer.sol";
import "vyper-storage/VyperStorage.sol";
import "src/TestBase.sol";
import {IVyperFactory} from "./interfaces/IVyperFactory.sol";
import {IVyperAccount} from "./interfaces/IVyperAccount.sol";

contract ProfileVyper is AAGasProfileBase {
    bytes32 implSlot =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 beaconSlot =
        0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
    bytes32 adminSlot =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    VyperDeployer vyperDeployer = new VyperDeployer();

    IVyperFactory factory;

    IVyperAccount impl;

    function setUp() public {
        initializeTest("vyper");
        bytes memory initcode = newVyperStorage()
            .setFilePath("vyper_contracts/Account")
            .assignSlot("implementation", "address", implSlot)
            .assignSlot("admin", "address", adminSlot)
            .assignSlot("factory", "address", beaconSlot)
            .compile();

        address impl_;

        assembly {
            impl_ := create(0, add(initcode, 0x20), mload(initcode))
        }

        require(impl_ != address(0), "Account deployment failed");

        impl = IVyperAccount(impl_);

        factory = IVyperFactory(
            vyperDeployer.deployContract(
                "vyper_contracts/",
                "Factory",
                abi.encode(impl)
            )
        );

        setAccount();
    }

    function fillData(
        address _to,
        uint256 _value,
        bytes memory _data
    ) internal view override returns (bytes memory) {
        return
            abi.encodeWithSelector(
                IVyperAccount.execute.selector,
                _to,
                _value,
                _data
            );
    }

    function getSignature(
        UserOperation memory _op
    ) internal view override returns (bytes memory) {
        return signUserOpHash(key, _op);
    }

    function createAccount(address _owner) internal override {
        factory.create_account(_owner, 0);
    }

    function getAccountAddr(
        address _owner
    ) internal view override returns (IAccount) {
        return IAccount(factory.get_address(_owner, 0));
    }

    function getInitCode(
        address _owner
    ) internal view override returns (bytes memory) {
        return
            abi.encodePacked(
                address(factory),
                abi.encodeWithSelector(
                    IVyperFactory.create_account.selector,
                    _owner,
                    0
                )
            );
    }

    function getDummySig(
        UserOperation memory _op
    ) internal pure override returns (bytes memory) {
        return
            hex"fffffffffffffffffffffffffffffff0000000000000000000000000000000007aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1c";
    }
}
