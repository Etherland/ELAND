// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.7.0;

/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/
contract Ownable {
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

    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
    * @dev Throws if called by any account other than the owner or if the contract has standalone state
    */
    modifier onlyOwner() {
        require(!standalone, 'denied : owner actions are locked when contract is running standalone');
        require(msg.sender != address(0), "denied : zero address has no rights");
        require(msg.sender == owner, "denied : method access is restricted to the contract owner");
        _;
    }

    function getRelinquishmentToken() public onlyOwner view returns (bytes32 _relinquishmentToken) {
        return relinquishmentToken;
    }

    /**
    * IRREVERSIBLE ACTION
    * @dev Allows the current owner to definitively and safely relinquish control of the contract.
    * @notice once owner renounces to its ownership, the contract runs in standalone mode meaning that : 
    *   - the contract is left without any owner
    *   - no other owner will ever be set for the remaining contract lifetime
    *   - no one will no longer ever have any access to owner-restricted methods
    */
    function renounceOwnership(bytes32 _relinquishmentToken) public onlyOwner {
        require(_relinquishmentToken == _relinquishmentToken, 'denied : a relinquishment token must be pre-set calling the preRenounceOwnership method');
        // require(landRegistryOpened, 'Land registry must be opened to renounce ownership');
        emit OwnershipRenounced(owner);
        standalone = true;
        owner = address(0);
    }

    /**
    * @dev Allows the current owner to relinquish control of the contract.
    * @return _relinquishmentToken : auto generated bytes32 key 
    * @notice generating this key allows the contract owner to pass it to the renounceOwnership method in order to set the contract as standalone
    */
    function preRenounceOwnership() public onlyOwner returns(bytes32 _relinquishmentToken) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, uint8(msg.sender))));
        bytes32 salt = bytes32(rand);
        relinquishmentToken = salt;
        _relinquishmentToken = salt;
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param _newOwner The address to transfer ownership to.
    */
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    /**
    * @dev Transfers control of the contract to a newOwner.
    * @param _newOwner The address to transfer ownership to.
    */
    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0), "the new owner can't be the zero address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
