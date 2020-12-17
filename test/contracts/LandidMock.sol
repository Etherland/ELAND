pragma solidity ^0.7.0;

/**
 * * for test purpose only *
 * @title Landid Mock
 * @dev THIS METHOD MOCKS THE REAL ETHERLAND LANDID NFT ERC721 SMART CONTRACT
 * * for test purpose only
*/
contract LandidMock {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    /**
    * @dev Mock for the `adminRightsOf` method of Etherland LANDID ERC721 Non Fungible Token
    * @return int16 corresponding to the maximum level of accreditation for administrators
    */
    function adminRightsOf(address _admin) public view returns(int16) {
        if (_admin == owner) return int16(2);
        else return int16(0);
    }

}