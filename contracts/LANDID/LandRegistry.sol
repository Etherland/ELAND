import '../ERC20/ERC20Mintable.sol';

/**
 * @title Land Registry
 *
 * @dev Etherland - Decentralized Land Registration Protocol
 *  Allows ELAND owners to register lands in the Etherland eco-system by minting Etherland ERC721 LANDID NFT
 *
 * @author Mathieu Lecoq
 *  december 20th 2020 
 *
 * @dev Property
 *  all rights are reserved to Etherland ltd
*/
contract LandRegistry is ERC20Mintable {

    modifier isNftAdmin() {
        landid = iLANDID(landidNftAddress);
        int16 adminRight = landid.adminRightsOf(_msgSender());
        require((adminRight > 0) && (adminRight < 3), 'denied : restricted to LANDID NFT admins');
        _;
    }

    /**
    * @dev Allow any NFT admin to set public prices for record rights
    * @param _indexedRecordOffers Array of indexed public ELAND prices of record rights
    * @return boolean indicating operation success/failure
    */
    function setRecordRightsOffers(uint[] memory _indexedRecordOffers) public isNftAdmin returns (bool) {
        recordRightsOffers = _indexedRecordOffers;
        return true;
    }

    /**
    * @dev Let owner open land registry to allow ELAND owners register new lands
    * @return boolean indicating operation success/failure
    */
    function openLandRegistry() public isNftAdmin returns (bool) {
        landRegistryOpened = true;
        return true;
    }

    /**
    * @dev Let owner close land registry to avoid ELAND owners register new lands
    * @return boolean indicating operation success/failure
    */
    function closeLandRegistry() public isNftAdmin returns (bool) {
        landRegistryOpened = false;
        return true;
    }

    /**
    * @dev Allow ELAND owners to mint LANDID automatically or not depending on current mode
    * @param recordIndex the index of record right offer to give corresponding to `recordRightsOffers` indexes
    * @return boolean indicating operation success/failure
    */
    function registerLand(uint recordIndex) public returns (bool) {
        require(landRegistryOpened && (landRegistration != address(0)), "denied : can't register new land for now");

        uint recordPrice = recordRightsOffers[recordIndex];
        require(recordPrice > 0, 'denied : no preset price for provided record right');

        bool transferred = transfer(landRegistration, recordPrice);
        require(transferred, 'denied : value corresponding to requested record right price has not been transferred');

        RecordRight memory recordRight;
        recordRight.time = block.timestamp;
        recordRight.right = recordIndex;

        // store record right
        registryRecordRights[_msgSender()].push(recordRight);

        return true;
    }

    /**
    * @dev Assert that a RecordRight is valid and can be consumed (has no attached tokenId and has a valid block.timestamp)
    * @param time a valid block.timestamp corresponding to the time of the record request
    * @param tokenId the LANDID NFT tokenId attached to the tested RecordRight 
    *       - 0 means available
    *       - any other value means that the right has already been consumed and that RecordRight is invalid
    * @return boolean indicating validity / availability of the record right
    */
    function validRecordRight(uint time, uint tokenId) internal pure returns(bool) {
        return(
            (time > 0)
            && (tokenId == 0)
        );
    }

    /**
    * @dev Allow LANDID NFT administrators to consume a registry record right of an owner indicating minting of the record request related NFT
    * @param _owner address of the RecordRight owner
    * @param recordIndex the index of record right offer that has been paid by _owner (must correspond to a `recordRightsOffers` index)
    * @param tokenId the LANDID NFT tokenId attached to attach to the first available/matching RecordRight 
    * @return boolean indicating if valid target right for `recordIndex` has been found and consumed
    */
    function consumeRecordRight(address _owner, uint recordIndex, uint tokenId) public isNftAdmin returns (bool) {
        RecordRight[] memory ownerRecordRights = registryRecordRights[_owner];
        require(ownerRecordRights.length > 0, 'denied : no record right found for provided address');

        bool consumed = false;

        for (uint i = 0; i < ownerRecordRights.length; i++) {
            RecordRight memory recordRight = ownerRecordRights[i];
            if (
                consumed == false
                && recordRight.right == recordIndex
                && validRecordRight(recordRight.time, recordRight.tokenId)
            ) {
                // consume right
                recordRight.tokenId = tokenId;
                registryRecordRights[_owner][i] = recordRight;
                consumed = true;
            }
        }

        if (consumed) return true;
        else revert('denied : no registry record right found for provided address');
    }

}