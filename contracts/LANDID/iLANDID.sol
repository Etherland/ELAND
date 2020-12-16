/**
* @title Etherland ERC721 LANDID administrator access granting system
*/
interface iLANDID {
    function adminRightsOf(address _admin) external view returns(int16);
}