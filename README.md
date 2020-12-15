# Smart Contracts for Etherland - ELAND ERC20 Token


## Contracts

`Etherland.sol` is ERC20-compatible and has the following characteristics:
	1.	TOTAL SUPPLY
		A fixed supply of pre-minted tokens
	2.	BURN
		Any token holder has the ability to burn its own tokens, 
		Contract `owner` has the ability to burn available tokens hold by the contract itself
		Both burn action removes the tokens from the total supply
	3.  


`Etherland.sol` flow:

Constructor initializes token with owner and token supply.
	•	Owner can transfer tokens in the name of the contract
	•	Token Supply is 1000000000 units (1 billion tokens)


We cloned OpenZeppelin code for `SafeMath`, `Ownable`, `Burnable`, `Pausable`, `Mintable` and `StandardToken` logic.

	* `SafeMath` provides arithmetic functions that throw exceptions when integer overflows occur.
	* `Ownable` keeps track of a contract owner and permits the transfer of ownership by the current owner.
	* `Burnable`provides a burning function that decrement the balance of the burner and the total supply
	* `Mintable` provides a minting function that increment the balance of the owner and the total supply.
	* `StandardToken` provides an implementation of the ERC20 standard.
	* `Pausable` allows owner to pause the Token Offering contract.
