
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
abstract contract ERC20Basic {
    function totalSupply() virtual public view returns (uint256);
    function balanceOf(address _who) virtual public view returns (uint256);
    function transfer(address _to, uint256 _value) virtual public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}
