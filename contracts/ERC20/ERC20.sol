pragma solidity ^0.7.0;

import "./ERC20Basic.sol";


/**
* @title ERC20 interface
* @dev see https://github.com/ethereum/EIPs/issues/20
*/
abstract contract ERC20 is ERC20Basic {
    function allowance(address _owner, address _spender)
        virtual public view returns (uint256);

    function transferFrom(address _from, address _to, uint256 _value)
        virtual public returns (bool);

    function approve(address _spender, uint256 _value) 
        virtual public returns (bool);
    
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
