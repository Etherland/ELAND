# Smart Contracts for Etherland - ELAND ERC20 Token


## Contracts Structure

### `CLONED SOURCE`
- We cloned OpenZeppelin Contracts v3 code for `SafeMath`, `ERC20`, `ERC20Burnable` and `ERC20Capped` logic.

	* `SafeMath` provides arithmetic functions that throw exceptions when integer overflows occur.
	* `ERC20` provides a basic implementation of the ERC20 standard
	* `ERC20Burnable`provides a burning function that decrement the balance of the burner and the total supply
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
	* `ERC20Capped` *provides a way to add a cap to the supply of tokens ensuring overflow will never happen* 
		- Constructor has been replaced by a method called `setImmutableCap` that is called during contract migration (*see Flow section of Etherland.sol definition down below*)
		- Internal calls to `_beforeTokenTransfer` are made to `ERC20.sol`

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

	2. CAP *The maximum amount of ELAND tokens the contract will ever mint* 
		- 1 000 000 000 (1 Billion) units

	3. TOTAL SUPPLY *A fixed total available supply of ELAND (will never be higher than the Maximum Supply)*
		- 1 000 000 000 (1 Billion) units

	4. CIRCULATING SUPPLY
		The number of circulating ELAND :
		- totalSupply - team - reserve - owner

	5. BURN
		- Any token holder has the ability to burn its own tokens, 
		- *Burn actions remove the tokens from the total supply*

	6. APPROVE
		- Any token holder has the ability to allow a tiers to spend/burn its own tokens

	7. LAND REGISTRY **see LandRegistry definition above**


	#### FLOW UPON CONTRACT CONSTRUCTION:
	- Maximum supply is pre-minted 
	- Address of the contract owner is initialized
	- Supply is partionnalized and distributed to 3 different wallets :
		- Team wallet : 10% of the maximum supply is allocated to the team
		- Reserve : 20% of the maximum supply is allocated to the reserve
		- Owner : 70% of the maximum supply is transfered to the contract owner
	- Minting is definitvely closed assuring that no more tokens than the maximum supply will be minted

