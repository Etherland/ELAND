import './LANDID/iLANDID.sol';

contract Storage {

    // 
    // Ownable.sol
    //
    /**
    * @dev Etherland owner address
    */
    address public owner;
    /**
    * @dev Generated random salt acting in the safecheck mechanism when renouncing contract ownership 
    */
    bytes32 internal relinquishmentToken;
    /**
    * @dev Standalone mode
    * @notice see renounceOwnership method's notice below
    */
    bool public standalone = false;

    //
    // ERC20.sol
    //
    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal _allowances;
    uint256 internal _totalSupply;
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;

    //
    // ERC20Capped.sol
    //
    uint256 internal _cap;
    // Instance of Etherland LANDID NFT Administrator rights verifier

    //
    // LandRegistry.sol
    //
    iLANDID landid;
    // address of Etherland LANDID NFT
    address public landidNftAddress;
    // address of the wallet dedicated to land registration
    address internal landRegistration;
    // Land registry can be opened or closed
    bool public landRegistryOpened = false;
    // Land registry rights offers
    uint[] public recordRightsOffers;
    // Schema defining a Right to register a new land
    struct RecordRight {
        // the block timestamp of the record request
        uint time;
        // the tokenId representing the resultant minted LANDID NFT token id
        uint tokenId;
        // The new land record right which was purchased in ELAND. Registration rights are considered available when the tokenId is LESS than 1
        uint right;
    }
    // Land registry record rights tracking
    mapping (address => RecordRight[]) public registryRecordRights;

    //
    // ERC20Mintable.sol
    //
    bool _mintingFinished = false;

    // 
    // Etherland.sol
    //
    /**
    * @dev Contact initialization state
    * initialized state is set upon construction
    * MUST be initialized to be valid
    */
    bool public initialized = false;
    /**
    * @dev Etherland Wallets
    */
    address public team;
    address public reserve;
}