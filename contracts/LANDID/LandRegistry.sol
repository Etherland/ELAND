import './iLANDID.sol';
import '../ERC20/MintableToken.sol';

// @todo : Etherland is LandRegistry
/**
* @title Land Registration
* @dev Etherland - Decentralized Land Registration Protocol
* @dev Allow ELAND owners to register lands in the Etherland eco-system by minting Etherland ERC721 LANDID NFT
*/
contract LandRegistry is MintableToken {
    
    // Instance of Etherland LANDID NFT Administrator rights verifier
    iLANDID landid;
    // address of Etherland LANDID NFT
    address public landidNftAddress;
    // address of the wallet dedicated to land registration
    address internal landRegistration;
    // Land registry can be opened or closed
    bool public landRegistryOpened = true;
    // Land registry right 
    uint[] internal recordRightsPrices;
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

    modifier isNftAdmin() {
        landid = iLANDID(landidNftAddress);
        int16 adminRight = landid.adminRightsOf(msg.sender);
        require((adminRight > 0) && (adminRight < 3), 'denied : restricted to LANDID NFT admins');
        _;
    }

    function setLandidNftAddress(address _landidNftAddress) public isNftAdmin returns (bool) {
        landidNftAddress = _landidNftAddress;
        return true;
    }

    function setRecordRightsPrices(uint[] memory _indexedRecordPrices) public isNftAdmin returns (bool) {
        recordRightsPrices = _indexedRecordPrices;
        return true;
    }

    /**
    * @dev Let owner open land registry to allow ELAND owners register new lands
    */
    function openLandRegistry() public isNftAdmin returns (bool) {
        landRegistryOpened = true;
        return true;
    }

    /**
    * @dev Let owner close land registry to avoid ELAND owners register new lands
    */
    function closeLandRegistry() public isNftAdmin returns (bool) {
        landRegistryOpened = false;
        return true;
    }

    /**
    * @dev Allow ELAND owners to mint LANDID automatically or not depending on current mode
    */
    function registerLand(uint _recordRight) public returns (bool) {
        require(landRegistryOpened && (landRegistration != address(0)), "denied : can't register new land for now");

        uint recordPrice = recordRightsPrices[_recordRight];
        require(recordPrice > 0, 'denied : no preset price for provided record right');

        bool transferred = transfer(landRegistration, recordPrice);
        require(transferred, 'denied : value corresponding to requested record right price has not been transferred');

        RecordRight memory recordRight;
        recordRight.time = block.timestamp;
        recordRight.right = _recordRight;

        // store record right
        registryRecordRights[msg.sender].push(recordRight);

        return true;
    }

    function validRecordRight(uint time, uint right, uint tokenId) internal pure returns(bool) {
        return(
            (time > 0)
            && (right > 0)
            && (tokenId == 0)
        );
    }

    /**
    * @dev
    */
    function consumeRegistryRight(address _owner, uint recordIndex, uint tokenId) public isNftAdmin returns (bool) {
        RecordRight[] memory ownerRecordRights = registryRecordRights[_owner];
        require(ownerRecordRights.length > 0, 'denied : no record right found for provided address');

        bool consumed = false;

        for (uint i = 0; i < ownerRecordRights.length; i++) {
            RecordRight memory recordRight = ownerRecordRights[i];
            if (
                consumed == false
                && recordRight.right == recordIndex
                && validRecordRight(recordRight.time, recordRight.right, recordRight.tokenId)
            ) {
                // consume right
                recordRight.tokenId = tokenId;
                registryRecordRights[_owner][i] = recordRight;
                consumed = true;
            }
        }

        return consumed;
    }

}