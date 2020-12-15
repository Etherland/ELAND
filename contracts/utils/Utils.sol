pragma solidity ^0.7.0;

/**
* @dev Utilities internal functions
*/
contract Utils {

    /**
    * @return uint representing the amount computed by _percent% of _amount
    */
    function percentOf(uint _total, uint _percent) internal pure returns(uint) {
        return (_total * (_percent/100));
    }

}