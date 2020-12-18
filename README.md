# Smart Contracts for Etherland - ELAND ERC20 Token


## Contracts Structure

### `CLONED SOURCE`
- We cloned OpenZeppelin Contracts v3 code for `SafeMath`, `Burnable`, and `StandardToken` logic.

	* `SafeMath` provides arithmetic functions that throw exceptions when integer overflows occur.
	* `Burnable`provides a burning function that decrement the balance of the burner and the total supply
	* `StandardToken` provides a basic implementation of the ERC20 standard
	* `MintableToken` provides the token a mintable ability in order to generate the supply

### `UPGRADED CLONED SOURCE`
- We cloned OpenZeppelin Contracts v3 code for `Ownable` and added some logic.

* `Ownable` *keeps track of a contract owner and permits the transfer of ownership by the current owner*
	- This part of the logic originally propose a straight method named `renounceOwnership`.
	- We've enhanced this part of the contract's logic by adding a new layer of security materialized by a new method allowing the current owner to definitively relinquish control of the contract in a safe way. 
	- This safe check mechanism has been implemented to absolutely avoid situations where a method is unwantely called which could potentially lock the all ecosystem permanently.
	- To make sure this will never happens, we've defined the standalone release process in 2 steps : 
		1. First, the owner calls `preRenounceOwnership` method to generate, store and retrieve an hexadecimal random key 
			named `relinquishmentToken`.
		2. In a second time, the owner calls `renounceOwnership` method with `relinquishmentToken` to renounce to his ownership and set the standalone state to true.

### `INTERNAL SOURCE`

* `LandRegistry.sol` *Etherland Decentralized Land Registration Protocol*
	- On the Etherland Metaverse, any token holder has the ability to register a new land, to do so, they must exchange *ELAND* against *Land Record Rights* which are
	a sub-asset of the ecosystem. 
	- Land Record Rights offers and prices in ELAND are stored on-chain and can be retrieved from a method named `recordRightsOffers` *(rights prices are indexed)* 
	- Those rights are detailed on our website at https://etherland.io/dashboard/?ua=newitem

* `Etherland.sol` *contract assembling the code for Etherland logic*

	#### GENERAL CHARASTERISTICS:
	1. IDENTIFICATION
		- Name : Etherland
		- Symbol : ELAND
		- Decimals : 18

	2. MAXIMUM SUPPLY *The maximum amount of ELAND tokens the contract will ever mint* 
		- 1 000 000 000 (1 Billion) units

	3. TOTAL SUPPLY *A fixed total available supply of ELAND (will never be higher than the Maximum Supply)*
		- 1 000 000 000 (1 Billion) units

	4. CIRCULATING SUPPLY
		The number of circulating ELAND :
		- totalSupply - team - reserve - owner

	5. BURN
		- Any token holder has the ability to burn its own tokens, 
		- Contract `owner` has the ability to burn available tokens hold by the contract itself
		- *Both burn action removes the tokens from the total supply*

	6. APPROVE

	6. LAND REGISTRY **see LandRegistry definition above**


	#### FLOW UPON CONTRACT CONSTRUCTION:
	- Maximum supply is pre-minted 
	- Address of the contract owner is initialized
	- Supply is partionnalized and distributed to 3 different wallets :
		- Team wallet : 10% of the maximum supply is allocated to the team
		- Reserve : 20% of the maximum supply is allocated to the reserve
		- Owner : 70% of the maximum supply is transfered to the contract owner
	- Minting is definitvely closed assuring that no more tokens than the maximum supply will be minted

