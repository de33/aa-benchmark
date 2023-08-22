pragma solidity ^0.8.0;

import "./TestBase.sol";
import {KernelFactory} from "kernel/src/factory/KernelFactory.sol";
import {Kernel, KernelStorage, Operation} from "kernel/src/Kernel.sol";
import {ECDSAValidator } from "kernel/src/validator/ECDSAValidator.sol";
bytes constant KERNEL_FACTORY_CODE = hex"608060405234801561001057600080fd5b50600436106100575760003560e01c8063037637aa1461005c5780631bb12e691461009f578063296601cd146100b25780636c2f70fd146100c5578063b0d691fe146100ec575b600080fd5b6100837f000000000000000000000000727a10897e70cd3ab1a6e43d59a12ab0895a499581565b6040516001600160a01b03909116815260200160405180910390f35b6100836100ad366004610471565b610113565b6100836100c0366004610471565b610243565b6100837f000000000000000000000000eb8206e02f6ab1884cfea58cc7babda7d55ac95781565b6100837f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278981565b6000808585858560405160200161012d9493929190610508565b604051602081830303815290604052805190602001209050610237816040518060200161015990610464565b6020820181038252601f19601f820116604052507f000000000000000000000000727a10897e70cd3ab1a6e43d59a12ab0895a4995897f000000000000000000000000eb8206e02f6ab1884cfea58cc7babda7d55ac9578a8a6040516024016101c5949392919061055e565b60408051601f19818403018152918152602080830180516001600160e01b031663cf7a1d7760e01b17905290516101fe939291016105b9565b60408051601f198184030181529082905261021c92916020016105fb565b60405160208183030381529060405280519060200120610426565b9150505b949350505050565b6000808585858560405160200161025d9493929190610508565b60405160208183030381529060405280519060200120905060006102f7826040518060200161028b90610464565b6020820181038252601f19601f820116604052507f000000000000000000000000727a10897e70cd3ab1a6e43d59a12ab0895a49958a7f000000000000000000000000eb8206e02f6ab1884cfea58cc7babda7d55ac9578b8b6040516024016101c5949392919061055e565b90506001600160a01b0381163b1561031257915061023b9050565b817f000000000000000000000000727a10897e70cd3ab1a6e43d59a12ab0895a4995887f000000000000000000000000eb8206e02f6ab1884cfea58cc7babda7d55ac957898960405160240161036b949392919061055e565b60408051601f198184030181529181526020820180516001600160e01b031663cf7a1d7760e01b1790525161039f90610464565b6103aa9291906105b9565b8190604051809103906000f59050801580156103ca573d6000803e3d6000fd5b509250866001600160a01b0316836001600160a01b03167fa4ec333d142e947b3345528c6cbc210be703d984f8df2c3d589f2b3ea39f74378888886040516104149392919061062a565b60405180910390a35050949350505050565b600061043383833061043a565b9392505050565b6000604051836040820152846020820152828152600b8101905060ff815360559020949350505050565b6103088061064f83390190565b6000806000806060858703121561048757600080fd5b84356001600160a01b038116811461049e57600080fd5b9350602085013567ffffffffffffffff808211156104bb57600080fd5b818701915087601f8301126104cf57600080fd5b8135818111156104de57600080fd5b8860208285010111156104f057600080fd5b95986020929092019750949560400135945092505050565b6bffffffffffffffffffffffff198560601b16815282846014830137601492019182015260340192915050565b81835281816020850137506000828201602090810191909152601f909101601f19169091010190565b6001600160a01b0385811682528416602082015260606040820181905260009061058b9083018486610535565b9695505050505050565b60005b838110156105b0578181015183820152602001610598565b50506000910152565b60018060a01b038316815260406020820152600082518060408401526105e6816060850160208701610595565b601f01601f1916919091016060019392505050565b6000835161060d818460208801610595565b835190830190610621818360208801610595565b01949350505050565b60408152600061063e604083018587610535565b905082602083015294935050505056fe6080604052604051610308380380610308833981016040819052610022916101be565b6001600160a01b0382166100965760405162461bcd60e51b815260206004820152603060248201527f4549503139363750726f78793a20696d706c656d656e746174696f6e2069732060448201526f746865207a65726f206164647265737360801b60648201526084015b60405180910390fd5b7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc82815581511561017c576000836001600160a01b0316836040516100db919061028c565b600060405180830381855af49150503d8060008114610116576040519150601f19603f3d011682016040523d82523d6000602084013e61011b565b606091505b505090508061017a5760405162461bcd60e51b815260206004820152602560248201527f4549503139363750726f78793a20636f6e7374727563746f722063616c6c2066604482015264185a5b195960da1b606482015260840161008d565b505b5050506102a8565b634e487b7160e01b600052604160045260246000fd5b60005b838110156101b557818101518382015260200161019d565b50506000910152565b600080604083850312156101d157600080fd5b82516001600160a01b03811681146101e857600080fd5b60208401519092506001600160401b038082111561020557600080fd5b818501915085601f83011261021957600080fd5b81518181111561022b5761022b610184565b604051601f8201601f19908116603f0116810190838211818310171561025357610253610184565b8160405282815288602084870101111561026c57600080fd5b61027d83602083016020880161019a565b80955050505050509250929050565b6000825161029e81846020870161019a565b9190910192915050565b6052806102b66000396000f3fe60806040526000602d7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc5490565b90503660008037600080366000845af43d6000803e808015604d573d6000f35b3d6000fd";
bytes constant KERNEL_CODE = hex"6080604052600436106101235760003560e01c806354fd4d50116100a0578063bc197c8111610064578063bc197c81146104d1578063d087d28814610500578063d1f5789414610515578063d541622114610535578063f23a6e61146105555761012a565b806354fd4d501461040b57806355b14f501461043c57806357b750471461045c57806388e7fd0614610471578063b0d691fe1461049d5761012a565b80633659cfe6116100e75780633659cfe6146103105780633a871cdd146103305780633e1b08121461035e57806351166ba01461037e57806351945447146103eb5761012a565b806306fdde03146102165780630b3dc3541461025e578063150b7a021461028b5780631626ba7e146102d057806329f8b174146102f05761012a565b3661012a57005b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278916146101a75760405162461bcd60e51b815260206004820152601c60248201527f6163636f756e743a206e6f742066726f6d20656e747279706f696e740000000060448201526064015b60405180910390fd5b600080356001600160e01b031916905060006101c1610582565b6001600160e01b0319831660009081526002919091016020526040812054600160601b90046001600160a01b0316915036908037600080366000845af43d6000803e80801561020f573d6000f35b3d6000fd5b005b34801561022257600080fd5b506102486040518060400160405280600681526020016512d95c9b995b60d21b81525081565b6040516102559190611b60565b60405180910390f35b34801561026a57600080fd5b506102736105b6565b6040516001600160a01b039091168152602001610255565b34801561029757600080fd5b506102b76102a6366004611be3565b630a85bd0160e11b95945050505050565b6040516001600160e01b03199091168152602001610255565b3480156102dc57600080fd5b506102b76102eb366004611c55565b6105d9565b3480156102fc57600080fd5b5061021461030b366004611cce565b6106f4565b34801561031c57600080fd5b5061021461032b366004611d68565b6108c8565b34801561033c57600080fd5b5061035061034b366004611d85565b610976565b604051908152602001610255565b34801561036a57600080fd5b50610350610379366004611dd8565b610e33565b34801561038a57600080fd5b5061039e610399366004611e01565b610ecd565b60408051825165ffffffffffff908116825260208085015190911690820152828201516001600160a01b039081169282019290925260609283015190911691810191909152608001610255565b3480156103f757600080fd5b50610214610406366004611e1c565b610f67565b34801561041757600080fd5b5061024860405180604001604052806005815260200164181718171960d91b81525081565b34801561044857600080fd5b50610214610457366004611e93565b6110a3565b34801561046857600080fd5b506102b76111da565b34801561047d57600080fd5b506104866111f0565b60405165ffffffffffff9091168152602001610255565b3480156104a957600080fd5b506102737f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278981565b3480156104dd57600080fd5b506102b76104ec366004611f12565b63bc197c8160e01b98975050505050505050565b34801561050c57600080fd5b50610350611213565b34801561052157600080fd5b50610214610530366004611e93565b6112aa565b34801561054157600080fd5b50610214610550366004611e01565b61139e565b34801561056157600080fd5b506102b7610570366004611fd0565b63f23a6e6160e01b9695505050505050565b6000806105b060017f439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dd9612061565b92915050565b60006105c0610582565b60010154600160501b90046001600160a01b0316919050565b6000806105e4610582565b6001015460405163199ed7c960e11b8152600160501b9091046001600160a01b03169063333daf929061061f9088908890889060040161209d565b602060405180830381865afa15801561063c573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061066091906120c0565b9050600061066d82611442565b905042816020015165ffffffffffff16111561069657506001600160e01b031991506106ed9050565b42816040015165ffffffffffff1610156106bd57506001600160e01b031991506106ed9050565b80516001600160a01b0316156106e057506001600160e01b031991506106ed9050565b50630b135d3f60e11b9150505b9392505050565b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278916148061072a57503330145b6107465760405162461bcd60e51b815260040161019e906120d9565b60405180608001604052808565ffffffffffff1681526020018465ffffffffffff168152602001876001600160a01b03168152602001866001600160a01b0316815250610791610582565b6001600160e01b031989166000908152600291909101602090815260409182902083518154928501518585015165ffffffffffff9283166001600160601b031990951694909417600160301b9290911691909102176001600160601b0316600160601b6001600160a01b0393841602178155606090930151600190930180546001600160a01b031916938216939093179092555163064acaab60e11b815290861690630c959556906108499085908590600401612126565b600060405180830381600087803b15801561086357600080fd5b505af1158015610877573d6000803e3d6000fd5b50506040516001600160a01b038089169350891691506001600160e01b03198a16907fed03d2572564284398470d3f266a693e29ddfff3eba45fc06c5e91013d32135390600090a450505050505050565b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27891614806108fe57503330145b61091a5760405162461bcd60e51b815260040161019e906120d9565b7f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc8181556040516001600160a01b038316907fbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b90600090a25050565b6000336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278916146109f05760405162461bcd60e51b815260206004820152601c60248201527f6163636f756e743a206e6f742066726f6d20656e747279506f696e7400000000604482015260640161019e565b6000610a00610140860186612142565b610a0f91600491600091612188565b610a18916121b2565b9050610a22610582565b6001015460e01b81166001600160e01b03191615610a7a5760405162461bcd60e51b81526020600482015260156024820152741ad95c9b995b0e881b5bd91948191a5cd8589b1959605a1b604482015260640161019e565b6000610a85866122ad565b9050600080610a976060890189612142565b610aa691600491600091612188565b610aaf916121b2565b90506001600160e01b03198416600003610b4757610acc886122ad565b9250610adc610140890189612142565b610aea916004908290612188565b8080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250505050610140840152610b2c610582565b60010154600160501b90046001600160a01b03169150610d59565b6001600160e01b03198416600160e01b03610c3d576000610b66610582565b6001600160e01b0319831660009081526002919091016020526040902060018101546001600160a01b03169350905082610bb957610ba2610582565b60010154600160501b90046001600160a01b031692505b610bc76101408a018a612142565b610bd5916004908290612188565b8080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152505050506101408501525460d081901b6001600160d01b031916600160301b90910460a01b65ffffffffffff60a01b16179450610d59565b6001600160e01b03198416600160e11b03610d4c57610c60610140890189612142565b610c6f91602491601091612188565b610c78916123bb565b60601c91503660008181610c9985610c946101408f018f612142565b6114b3565b60405163064acaab60e11b8152949d50929750909550935091506001600160a01b03871690630c95955690610cd49087908790600401612126565b600060405180830381600087803b158015610cee57600080fd5b505af1158015610d02573d6000803e3d6000fd5b5050505081818080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525050505061014088015250610d5992505050565b60019450505050506106ed565b8515610dab57604051600090339088908381818185875af1925050503d8060008114610da1576040519150601f19603f3d011682016040523d82523d6000602084013e610da6565b606091505b505050505b610e2785836001600160a01b0316633a871cdd868b8b6040518463ffffffff1660e01b8152600401610ddf939291906123e9565b6020604051808303816000875af1158015610dfe573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610e2291906120c0565b611864565b98975050505050505050565b604051631aab3f0d60e11b81523060048201526001600160c01b03821660248201526000907f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27896001600160a01b0316906335567e1a90604401602060405180830381865afa158015610ea9573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105b091906120c0565b604080516080810182526000808252602082018190529181018290526060810191909152610ef9610582565b6001600160e01b0319909216600090815260029290920160209081526040928390208351608081018552815465ffffffffffff8082168352600160301b820416938201939093526001600160a01b03600160601b909304831694810194909452600101541660608301525090565b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27891614610fdf5760405162461bcd60e51b815260206004820152601c60248201527f6163636f756e743a206e6f742066726f6d20656e747279706f696e7400000000604482015260640161019e565b600060606001836001811115610ff757610ff76124db565b036110465761103c8786868080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061193792505050565b909250905061108d565b611087878787878080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061196d92505050565b90925090505b8161109a57805160208201fd5b50505050505050565b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27891614806110d957503330145b6110f55760405162461bcd60e51b815260040161019e906120d9565b60006110ff610582565b60010154600160501b90046001600160a01b031690508361111e610582565b6001018054600160501b600160f01b031916600160501b6001600160a01b0393841602179055604051858216918316907fa35f5cdc5fbabb614b4cd5064ce5543f43dc8fab0e4da41255230eb8aba2531c90600090a360405163064acaab60e11b81526001600160a01b03851690630c959556906111a29086908690600401612126565b600060405180830381600087803b1580156111bc57600080fd5b505af11580156111d0573d6000803e3d6000fd5b5050505050505050565b60006111e4610582565b6001015460e01b919050565b60006111fa610582565b60010154640100000000900465ffffffffffff16919050565b604051631aab3f0d60e11b8152306004820152600060248201819052907f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27896001600160a01b0316906335567e1a90604401602060405180830381865afa158015611281573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906112a591906120c0565b905090565b60006112b4610582565b6001810154909150600160501b90046001600160a01b0316156113195760405162461bcd60e51b815260206004820152601c60248201527f6163636f756e743a20616c726561647920696e697469616c697a656400000000604482015260640161019e565b600181018054600160501b600160f01b031916600160501b6001600160a01b038716908102919091179091556040516000907fa35f5cdc5fbabb614b4cd5064ce5543f43dc8fab0e4da41255230eb8aba2531c908290a360405163064acaab60e11b81526001600160a01b03851690630c959556906111a29086908690600401612126565b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27891614806113d457503330145b6113f05760405162461bcd60e51b815260040161019e906120d9565b806113f9610582565b600101805463ffffffff191660e09290921c9190911790554261141a610582565b60010160046101000a81548165ffffffffffff021916908365ffffffffffff16021790555050565b60408051606081018252600080825260208201819052918101919091528160a081901c65ffffffffffff811660000361147e575065ffffffffffff5b604080516060810182526001600160a01b03909316835260d09490941c602083015265ffffffffffff16928101929092525090565b600036818181806114c860586038898b612188565b6114d1916124f1565b9050876058886114e1848361250f565b926114ee93929190612188565b90955093506000888861150284605861250f565b9061150e85607861250f565b9261151b93929190612188565b611524916124f1565b60001c905060006116057f3ce406685c1b3551d706d85a68afdaa49ac4e07b451ad9b8ff8b58c3ee9641768c8c8c60049060249261156493929190612188565b61156d916124f1565b60001c8d8d60249060389261158493929190612188565b61158d916123bb565b60601c8b8b6040516115a0929190612522565b6040519081900381206115ea95949392916020019485526001600160e01b031993909316602085015260408401919091526001600160a01b03166060830152608082015260a00190565b604051602081830303815290604052805190602001206119a5565b90506116ed611612610582565b60010154600160501b90046001600160a01b031663333daf92838d8d61163989607861250f565b90886116468b607861250f565b611650919061250f565b9261165d93929190612188565b6040518463ffffffff1660e01b815260040161167b9392919061209d565b602060405180830381865afa158015611698573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906116bc91906120c0565b60a06001600160601b038016901b8c8c6004906024926116de93929190612188565b6116e7916124f1565b16611864565b97508989836116fd86607861250f565b611707919061250f565b611712928290612188565b6040805160808101909152919650945080611731600a60048d8f612188565b61173a91612532565b60d01c81526020016117506010600a8d8f612188565b61175991612532565b60d01c815260200161176f603860248d8f612188565b611778916123bb565b60601c815260200161178e602460108d8f612188565b611797916123bb565b60601c90526117a4610582565b6001600160e01b03198d166000908152600291909101602090815260409182902083518154928501519385015165ffffffffffff9182166001600160601b031990941693909317600160301b9190941602929092176001600160601b0316600160601b6001600160a01b0392831602178255606090920151600190910180546001600160a01b03191691909216179055878a60588b611843878361250f565b9261185093929190612188565b975097509750505050939792965093509350565b6000816001600160a01b0316836001600160a01b031614611887575060016105b0565b60d083901c60a084901c65ffffffffffff81166000036118aa575065ffffffffffff5b60d084901c60a085901c65ffffffffffff81166000036118cd575065ffffffffffff5b8165ffffffffffff168465ffffffffffff1610156118e9578193505b8065ffffffffffff168365ffffffffffff161115611905578092505b60d08465ffffffffffff16901b60a08465ffffffffffff16901b886001600160a01b0316171794505050505092915050565b60006060600080845160208601875af491503d604051602082018101604052818152816000602083013e80925050509250929050565b6000606060008084516020860187895af191503d604051602082018101604052818152816000602083013e8092505050935093915050565b60006105b06119b26119f3565b8360405161190160f01b6020820152602281018390526042810182905260009060620160405160208183030381529060405280519060200120905092915050565b6000306001600160a01b037f000000000000000000000000eb8206e02f6ab1884cfea58cc7babda7d55ac95716148015611a4c57507f000000000000000000000000000000000000000000000000000000000000a4b146145b15611a7657507f37165730b67d46e563d465d047f19174ed8ae8cefeebd6071f3aeab1edc0090190565b50604080517f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f6020808301919091527f32ba20807d2fff2dbb34e0bcfa82982565bef566d4c0c633dc57b700b81c3427828401527fb30367effb941b728181f67f3bd24a38a4fff408ee7fb3b074425c9fb5e9be7460608301524660808301523060a0808401919091528351808403909101815260c0909201909252805191012090565b6000815180845260005b81811015611b4057602081850181015186830182015201611b24565b506000602082860101526020601f19601f83011685010191505092915050565b6020815260006106ed6020830184611b1a565b6001600160a01b0381168114611b8857600080fd5b50565b8035611b9681611b73565b919050565b60008083601f840112611bad57600080fd5b5081356001600160401b03811115611bc457600080fd5b602083019150836020828501011115611bdc57600080fd5b9250929050565b600080600080600060808688031215611bfb57600080fd5b8535611c0681611b73565b94506020860135611c1681611b73565b93506040860135925060608601356001600160401b03811115611c3857600080fd5b611c4488828901611b9b565b969995985093965092949392505050565b600080600060408486031215611c6a57600080fd5b8335925060208401356001600160401b03811115611c8757600080fd5b611c9386828701611b9b565b9497909650939450505050565b80356001600160e01b031981168114611b9657600080fd5b803565ffffffffffff81168114611b9657600080fd5b600080600080600080600060c0888a031215611ce957600080fd5b611cf288611ca0565b96506020880135611d0281611b73565b95506040880135611d1281611b73565b9450611d2060608901611cb8565b9350611d2e60808901611cb8565b925060a08801356001600160401b03811115611d4957600080fd5b611d558a828b01611b9b565b989b979a50959850939692959293505050565b600060208284031215611d7a57600080fd5b81356106ed81611b73565b600080600060608486031215611d9a57600080fd5b83356001600160401b03811115611db057600080fd5b84016101608187031215611dc357600080fd5b95602085013595506040909401359392505050565b600060208284031215611dea57600080fd5b81356001600160c01b03811681146106ed57600080fd5b600060208284031215611e1357600080fd5b6106ed82611ca0565b600080600080600060808688031215611e3457600080fd5b8535611e3f81611b73565b94506020860135935060408601356001600160401b03811115611e6157600080fd5b611e6d88828901611b9b565b909450925050606086013560028110611e8557600080fd5b809150509295509295909350565b600080600060408486031215611ea857600080fd5b8335611eb381611b73565b925060208401356001600160401b03811115611c8757600080fd5b60008083601f840112611ee057600080fd5b5081356001600160401b03811115611ef757600080fd5b6020830191508360208260051b8501011115611bdc57600080fd5b60008060008060008060008060a0898b031215611f2e57600080fd5b8835611f3981611b73565b97506020890135611f4981611b73565b965060408901356001600160401b0380821115611f6557600080fd5b611f718c838d01611ece565b909850965060608b0135915080821115611f8a57600080fd5b611f968c838d01611ece565b909650945060808b0135915080821115611faf57600080fd5b50611fbc8b828c01611b9b565b999c989b5096995094979396929594505050565b60008060008060008060a08789031215611fe957600080fd5b8635611ff481611b73565b9550602087013561200481611b73565b9450604087013593506060870135925060808701356001600160401b0381111561202d57600080fd5b61203989828a01611b9b565b979a9699509497509295939492505050565b634e487b7160e01b600052601160045260246000fd5b818103818111156105b0576105b061204b565b81835281816020850137506000828201602090810191909152601f909101601f19169091010190565b8381526040602082015260006120b7604083018486612074565b95945050505050565b6000602082840312156120d257600080fd5b5051919050565b6020808252602d908201527f6163636f756e743a206e6f742066726f6d20656e747279706f696e74206f722060408201526c37bbb732b91037b91039b2b63360991b606082015260800190565b60208152600061213a602083018486612074565b949350505050565b6000808335601e1984360301811261215957600080fd5b8301803591506001600160401b0382111561217357600080fd5b602001915036819003821315611bdc57600080fd5b6000808585111561219857600080fd5b838611156121a557600080fd5b5050820193919092039150565b6001600160e01b031981358181169160048510156121da5780818660040360031b1b83161692505b505092915050565b634e487b7160e01b600052604160045260246000fd5b60405161016081016001600160401b038111828210171561221b5761221b6121e2565b60405290565b600082601f83011261223257600080fd5b81356001600160401b038082111561224c5761224c6121e2565b604051601f8301601f19908116603f01168101908282118183101715612274576122746121e2565b8160405283815286602085880101111561228d57600080fd5b836020870160208301376000602085830101528094505050505092915050565b600061016082360312156122c057600080fd5b6122c86121f8565b6122d183611b8b565b81526020830135602082015260408301356001600160401b03808211156122f757600080fd5b61230336838701612221565b6040840152606085013591508082111561231c57600080fd5b61232836838701612221565b60608401526080850135608084015260a085013560a084015260c085013560c084015260e085013560e0840152610100915081850135828401526101209150818501358181111561237857600080fd5b61238436828801612221565b83850152506101409150818501358181111561239f57600080fd5b6123ab36828801612221565b8385015250505080915050919050565b6001600160601b031981358181169160148510156121da5760149490940360031b84901b1690921692915050565b606081526124036060820185516001600160a01b03169052565b60208401516080820152600060408501516101608060a085015261242b6101c0850183611b1a565b91506060870151605f19808685030160c08701526124498483611b1a565b9350608089015160e087015260a08901519150610100828188015260c08a01519250610120838189015260e08b0151935061014084818a0152828c0151868a0152818c0151955083898803016101808a01526124a58787611b1a565b9650808c0151955050505080868503016101a087015250506124c78282611b1a565b602085019690965250505060400152919050565b634e487b7160e01b600052602160045260246000fd5b803560208310156105b057600019602084900360031b1b1692915050565b808201808211156105b0576105b061204b565b8183823760009101908152919050565b6001600160d01b031981358181169160068510156121da5760069490940360031b84901b169092169291505056";
bytes constant TEMP_KERNEL_CODE = hex"6080604052600436106100745760003560e01c80634be5cd9f1161004e5780634be5cd9f1461027957806354fd4d501461029c578063b0d691fe146102cd578063cf7a1d77146103195761007b565b806306fdde03146101ca5780631626ba7e146102125780633a871cdd1461024b5761007b565b3661007b57005b3080546001600160a01b03167f360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc81815560006100b5610339565b6001015460405163064acaab60e11b8152600160501b9091046001600160a01b031691508190630c959556906100f2906002880190600401611151565b600060405180830381600087803b15801561010c57600080fd5b505af1158015610120573d6000803e3d6000fd5b50505050600061012d3090565b600101546001600160a01b0316905080156101a45760405163064acaab60e11b81526001600160a01b03821690630c95955690610171906003300190600401611151565b600060405180830381600087803b15801561018b57600080fd5b505af115801561019f573d6000803e3d6000fd5b505050505b3660008037600080366000875af43d6000803e8080156101c3573d6000f35b3d6000fd5b005b3480156101d657600080fd5b506101fc6040518060400160405280600681526020016512d95c9b995b60d21b81525081565b6040516102099190611222565b60405180910390f35b34801561021e57600080fd5b5061023261022d366004611277565b61036d565b6040516001600160e01b03199091168152602001610209565b34801561025757600080fd5b5061026b6102663660046112c3565b610497565b604051908152602001610209565b34801561028557600080fd5b5061028e6107ec565b604051610209929190611317565b3480156102a857600080fd5b506101fc60405180604001604052806005815260200164181718171960d91b81525081565b3480156102d957600080fd5b506103017f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278981565b6040516001600160a01b039091168152602001610209565b34801561032557600080fd5b506101c861033436600461136b565b610895565b60008061036760017f439ffe7df606b78489639bc0b827913bd09e1246fa6802968a5b3694c53e0dd96113e6565b92915050565b6000806103e661037b610339565b600101600a9054906101000a90046001600160a01b031663333daf9260e01b8787876040516024016103af93929190611422565b60408051601f198184030181529190526020810180516001600160e01b03166001600160e01b031990931692909217909152610a00565b9150506000818060200190518101906103ff9190611445565b9050600061040c82610a54565b905042816020015165ffffffffffff16111561043657506001600160e01b03199250610490915050565b42816040015165ffffffffffff16101561045e57506001600160e01b03199250610490915050565b80516001600160a01b03161561048257506001600160e01b03199250610490915050565b50630b135d3f60e11b925050505b9392505050565b6000336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278916146105165760405162461bcd60e51b815260206004820152601c60248201527f6163636f756e743a206e6f742066726f6d20656e747279506f696e740000000060448201526064015b60405180910390fd5b600061052661014086018661145e565b610535916004916000916114a5565b61053e916114cf565b9050600061054b866115cc565b905060008061055d606089018961145e565b61056c916004916000916114a5565b610575916114cf565b90506001600160e01b0319841660000361060d57610592886115cc565b92506105a261014089018961145e565b6105b09160049082906114a5565b8080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152505050506101408401526105f2610339565b60010154600160501b90046001600160a01b0316915061074a565b6001600160e01b03198416600160e11b0361073d5761063061014089018961145e565b61063f916024916010916114a5565b610648916116db565b60601c91503660008181610669856106646101408f018f61145e565b610ac5565b604051949d509297509095509350915060009061069b90889063064acaab60e11b906103af908990899060240161170e565b509050806106f65760405162461bcd60e51b815260206004820152602260248201527f6163636f756e743a20656e61626c65206d6f646520656e61626c65206661696c604482015261195960f21b606482015260840161050d565b82828080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152505050506101408901525061074a9350505050565b6001945050505050610490565b851561079c57604051600090339088908381818185875af1925050503d8060008114610792576040519150601f19603f3d011682016040523d82523d6000602084013e610797565b606091505b505050505b60006107bf83633a871cdd60e01b868b8b6040516024016103af93929190611722565b9150506107df86828060200190518101906107da9190611445565b610ecf565b9998505050505050505050565b3080546002820180546001600160a01b039092169260609290919061081090611117565b80601f016020809104026020016040519081016040528092919081815260200182805461083c90611117565b80156108895780601f1061085e57610100808354040283529160200191610889565b820191906000526020600020905b81548152906001019060200180831161086c57829003601f168201915b50505050509150509091565b600061089f610339565b6001810154909150600160501b90046001600160a01b0316156109045760405162461bcd60e51b815260206004820152601c60248201527f6163636f756e743a20616c726561647920696e697469616c697a656400000000604482015260640161050d565b6001810180547fffff0000000000000000000000000000000000000000ffffffffffffffffffff16600160501b6001600160a01b03881602179055833080546001600160a01b0319166001600160a01b03929092169190911790558282306002019161097191908361185f565b50600061099386630c95955660e01b86866040516024016103af92919061170e565b509050806109f85760405162461bcd60e51b815260206004820152602c60248201527f6163636f756e743a20656e61626c65206661696c65642077697468206465666160448201526b3ab63a3b30b634b230ba37b960a11b606482015260840161050d565b505050505050565b600060606000808451602086016000885af260405160203d0181016040523d81523d6000602083013e909250905081610a4d578060405162461bcd60e51b815260040161050d9190611222565b9250929050565b60408051606081018252600080825260208201819052918101919091528160a081901c65ffffffffffff8116600003610a90575065ffffffffffff5b604080516060810182526001600160a01b03909316835260d09490941c602083015265ffffffffffff16928101929092525090565b60003681818180610ada60586038898b6114a5565b610ae391611920565b905087605888610af3848361193e565b92610b00939291906114a5565b909550935060008888610b1484605861193e565b90610b2085607861193e565b92610b2d939291906114a5565b610b3691611920565b60001c90506000610c177f3ce406685c1b3551d706d85a68afdaa49ac4e07b451ad9b8ff8b58c3ee9641768c8c8c600490602492610b76939291906114a5565b610b7f91611920565b60001c8d8d602490603892610b96939291906114a5565b610b9f916116db565b60601c8b8b604051610bb2929190611951565b604051908190038120610bfc95949392916020019485526001600160e01b031993909316602085015260408401919091526001600160a01b03166060830152608082015260a00190565b60405160208183030381529060405280519060200120610fa2565b90506000610c86610c26610339565b60010154600160501b90046001600160a01b031663199ed7c960e11b848e8e610c508a607861193e565b9089610c5d8c607861193e565b610c67919061193e565b92610c74939291906114a5565b6040516024016103af93929190611422565b915050610cd681806020019051810190610ca09190611445565b60a06bffffffffffffffffffffffff8016901b8d8d600490602492610cc7939291906114a5565b610cd091611920565b16610ecf565b98508a8a84610ce687607861193e565b610cf0919061193e565b610cfb9282906114a5565b9550955060405180608001604052808c8c600490600a92610d1e939291906114a5565b610d2791611961565b60d01c65ffffffffffff1681526020018c8c600a90601092610d4b939291906114a5565b610d5491611961565b60d01c65ffffffffffff1681526020018c8c602490603892610d78939291906114a5565b610d81916116db565b60601c6001600160a01b031681526020018c8c601090602492610da6939291906114a5565b610daf916116db565b60601c9052610dbc610339565b6001600160e01b03198e166000908152600291909101602090815260409182902083518154928501519385015165ffffffffffff9182166bffffffffffffffffffffffff199094169390931766010000000000009190941602929092176bffffffffffffffffffffffff16600160601b6001600160a01b0392831602178255606090920151600190910180546001600160a01b03191691909216179055610e67602460108c8e6114a5565b610e70916116db565b60013090810180546001600160a01b03191660609390931c92909217909155600301610e9d888a8361185f565b50888b60588c610ead888361193e565b92610eba939291906114a5565b98509850985050505050939792965093509350565b6000816001600160a01b0316836001600160a01b031614610ef257506001610367565b60d083901c60a084901c65ffffffffffff8116600003610f15575065ffffffffffff5b60d084901c60a085901c65ffffffffffff8116600003610f38575065ffffffffffff5b8165ffffffffffff168465ffffffffffff161015610f54578193505b8065ffffffffffff168365ffffffffffff161115610f70578092505b60d08465ffffffffffff16901b60a08465ffffffffffff16901b886001600160a01b0316171794505050505092915050565b6000610367610faf610ff0565b8360405161190160f01b6020820152602281018390526042810182905260009060620160405160208183030381529060405280519060200120905092915050565b6000306001600160a01b037f000000000000000000000000727a10897e70cd3ab1a6e43d59a12ab0895a49951614801561104957507f000000000000000000000000000000000000000000000000000000000001388146145b1561107357507fb13cf7d934cfcee87175f67dc7e9addc04a21a7b92b443f44285eecc4a7da6e690565b50604080517f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f6020808301919091527f32ba20807d2fff2dbb34e0bcfa82982565bef566d4c0c633dc57b700b81c3427828401527fb30367effb941b728181f67f3bd24a38a4fff408ee7fb3b074425c9fb5e9be7460608301524660808301523060a0808401919091528351808403909101815260c0909201909252805191012090565b600181811c9082168061112b57607f821691505b60208210810361114b57634e487b7160e01b600052602260045260246000fd5b50919050565b600060208083526000845461116581611117565b8084870152604060018084166000811461118657600181146111a0576111ce565b60ff1985168984015283151560051b8901830195506111ce565b896000528660002060005b858110156111c65781548b82018601529083019088016111ab565b8a0184019650505b509398975050505050505050565b6000815180845260005b81811015611202576020818501810151868301820152016111e6565b506000602082860101526020601f19601f83011685010191505092915050565b60208152600061049060208301846111dc565b60008083601f84011261124757600080fd5b50813567ffffffffffffffff81111561125f57600080fd5b602083019150836020828501011115610a4d57600080fd5b60008060006040848603121561128c57600080fd5b83359250602084013567ffffffffffffffff8111156112aa57600080fd5b6112b686828701611235565b9497909650939450505050565b6000806000606084860312156112d857600080fd5b833567ffffffffffffffff8111156112ef57600080fd5b8401610160818703121561130257600080fd5b95602085013595506040909401359392505050565b6001600160a01b038316815260406020820181905260009061133b908301846111dc565b949350505050565b6001600160a01b038116811461135857600080fd5b50565b803561136681611343565b919050565b6000806000806060858703121561138157600080fd5b843561138c81611343565b9350602085013561139c81611343565b9250604085013567ffffffffffffffff8111156113b857600080fd5b6113c487828801611235565b95989497509550505050565b634e487b7160e01b600052601160045260246000fd5b81810381811115610367576103676113d0565b81835281816020850137506000828201602090810191909152601f909101601f19169091010190565b83815260406020820152600061143c6040830184866113f9565b95945050505050565b60006020828403121561145757600080fd5b5051919050565b6000808335601e1984360301811261147557600080fd5b83018035915067ffffffffffffffff82111561149057600080fd5b602001915036819003821315610a4d57600080fd5b600080858511156114b557600080fd5b838611156114c257600080fd5b5050820193919092039150565b6001600160e01b031981358181169160048510156114f75780818660040360031b1b83161692505b505092915050565b634e487b7160e01b600052604160045260246000fd5b604051610160810167ffffffffffffffff81118282101715611539576115396114ff565b60405290565b600082601f83011261155057600080fd5b813567ffffffffffffffff8082111561156b5761156b6114ff565b604051601f8301601f19908116603f01168101908282118183101715611593576115936114ff565b816040528381528660208588010111156115ac57600080fd5b836020870160208301376000602085830101528094505050505092915050565b600061016082360312156115df57600080fd5b6115e7611515565b6115f08361135b565b815260208301356020820152604083013567ffffffffffffffff8082111561161757600080fd5b6116233683870161153f565b6040840152606085013591508082111561163c57600080fd5b6116483683870161153f565b60608401526080850135608084015260a085013560a084015260c085013560c084015260e085013560e0840152610100915081850135828401526101209150818501358181111561169857600080fd5b6116a43682880161153f565b8385015250610140915081850135818111156116bf57600080fd5b6116cb3682880161153f565b8385015250505080915050919050565b6bffffffffffffffffffffffff1981358181169160148510156114f75760149490940360031b84901b1690921692915050565b60208152600061133b6020830184866113f9565b6060815261173c6060820185516001600160a01b03169052565b60208401516080820152600060408501516101608060a08501526117646101c08501836111dc565b91506060870151605f19808685030160c087015261178284836111dc565b9350608089015160e087015260a08901519150610100828188015260c08a01519250610120838189015260e08b0151935061014084818a0152828c0151868a0152818c0151955083898803016101808a01526117de87876111dc565b9650808c0151955050505080868503016101a0870152505061180082826111dc565b602085019690965250505060400152919050565b601f82111561185a57600081815260208120601f850160051c8101602086101561183b5750805b601f850160051c820191505b818110156109f857828155600101611847565b505050565b67ffffffffffffffff831115611877576118776114ff565b61188b836118858354611117565b83611814565b6000601f8411600181146118bf57600085156118a75750838201355b600019600387901b1c1916600186901b178355611919565b600083815260209020601f19861690835b828110156118f057868501358255602094850194600190920191016118d0565b508682101561190d5760001960f88860031b161c19848701351681555b505060018560011b0183555b5050505050565b8035602083101561036757600019602084900360031b1b1692915050565b80820180821115610367576103676113d0565b8183823760009101908152919050565b6001600160d01b031981358181169160068510156114f75760069490940360031b84901b169092169291505056";
address constant KERNEL_FACTORY_ADDRESS = 0x12358cA00141D09cB90253F05a1DD16bE93A8EE6;
address payable constant KERNEL_ADDRESS = payable(address(0xeB8206E02f6AB1884cfEa58CC7BabdA7d55aC957));
address constant TEMP_KERNEL_ADDRESS = 0x727A10897e70cd3Ab1a6e43d59A12ab0895A4995;

interface V2Factory {
    function createAccount(address valdiator, bytes calldata _data, uint256 _salt) external returns(address);
    function getAccountAddress(address validator, bytes calldata _data, uint256 _salt) external view returns(address);
}
contract ProfileKernel is AAGasProfileBase {
    Kernel kernelImpl;
    V2Factory factory;
    ECDSAValidator validator;
    address factoryOwner;
    function setUp() external {
        factoryOwner = address(0);
        initializeTest();
        factory = V2Factory(KERNEL_FACTORY_ADDRESS);
        vm.etch(KERNEL_FACTORY_ADDRESS, KERNEL_FACTORY_CODE);
        kernelImpl = Kernel(KERNEL_ADDRESS);
        vm.etch(KERNEL_ADDRESS, KERNEL_CODE);
        vm.etch(TEMP_KERNEL_ADDRESS, TEMP_KERNEL_CODE);
        vm.startPrank(factoryOwner);
        vm.stopPrank();
        validator = new ECDSAValidator();
        setAccount();
    }

    function fillData(address _to, uint256 _value, bytes memory _data) internal override returns(bytes memory) {
        return abi.encodeWithSelector(
            Kernel.execute.selector,
            _to,
            _value,
            _data,
            Operation.Call
        );
    }

    function createAccount(address _owner) internal override {
        if(address(account).code.length == 0)
            factory.createAccount(address(validator), abi.encodePacked(_owner), 0);
    }

    function getAccountAddr(address _owner) internal override returns(IAccount) {
        return IAccount(factory.getAccountAddress(address(validator), abi.encodePacked(_owner), 0));
    }

    function getInitCode(address _owner) internal override returns(bytes memory) {
        return abi.encodePacked(
            address(factory),
            abi.encodeWithSelector(
                factory.createAccount.selector,
                address(validator),
                abi.encodePacked(_owner),
                0
            )
        );
    }

    function getSignature(UserOperation memory _op) internal override returns(bytes memory) {
        return abi.encodePacked(bytes4(0x00000000), signUserOpHash(key, _op));
    }
}
