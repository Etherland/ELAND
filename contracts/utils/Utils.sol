pragma solidity ^0.7.0;

/**
* @dev Utilities internal functions
*/
contract Utils {

    /**
    * @return amount representing _percent % of _amount
    */
    function percentOf(uint _total, uint _percent) internal pure returns(uint amount) {
        amount = ((_total * _percent) / 100);
    }

}