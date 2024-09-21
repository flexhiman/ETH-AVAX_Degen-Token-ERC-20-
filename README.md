# Degen Token (ERC-20): Unlocking the Future of Gaming

## Overview
- I have imported ERC20 and Ownable functionality which will provide us ERC20 token and ownership-related functionality.
```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```

- I have declared a contract named DegenToken which will have the features of ERC20 and ownable contracts.
```solidity
contract DegenToken is ERC20, Ownable {
```

- These lines declare two public constant variables. bonusThreshold tells the amount needed to get the bonus which is 1000 here and the bonusAmount tells the amount of bonus the player will get if the amount reaches the threshold.  
``` solidity
    uint256 public constant bonusThreshold = 1000; // Bonus threshold in tokens
    uint256 public constant bonusAmount = 50;    // Bonus amount in tokens
```

- These lines declare a constructor which will execute only once when the contract is deployed.
- ERC20("Degen", "DGN") initializes the token with the name "Degen" and symbol "DGN".
- Ownable(msg.sender) sets the deployer (msg.sender) as the contract's owner.
```solidity 
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}
```

- These lines declare what will occur during the execution reedemToken, burnToken, transferToken, bonusToken, bonusAwarded.
```solidity 
    event RedeemToken(address account, uint rewardCategory);
    event BurnToken(address account, uint amount);
    event TransferToken(address from, address to, uint amount);
    event BonusAwarded(address account, uint amount);
```

- The mint functions mints the token to the address that will receive the minted tokens.
- checkAndRewardBonus(to) after minting, It checks if the recipient qualifies for a bonus.
```solidity
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        checkAndRewardBonus(to); // Check if the recipient is eligible for a bonus after minting
    }
```

- This function allows a player to transfer tokens to another player.
-  recipient is the address of the player to whom the tokens are sent. 
```solidity    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount); // Use _transfer to handle the balance and supply changes
        checkAndRewardBonus(recipient); // Check if the recipient is eligible for a bonus
        emit TransferToken(_msgSender(), recipient, amount); // Emit Transfer event
        return true;
    }
```

- This function checks if an account's balance reaches the bonus threshold. If it reaches the threshold amount then 50 tokens are minted to the account.
```solidity  
    function checkAndRewardBonus(address account) internal {
        if (balanceOf(account) >= bonusThreshold) {
            _mint(account, bonusAmount); // Mint bonus tokens to the user's account
            emit BonusAwarded(account, bonusAmount); // Emit event for awarded bonus
        }
    }
```

- This function returns the balance of msg.sender and gives the value of getBalance. 
```solidity
    function getBalance() public view returns (uint){
        return balanceOf(msg.sender);
    }
```

- This function allows players to redeem their tokens. And the required statement Ensures the player has enough tokens to redeem.
```solidity  
    function redeem(uint rewardCategory) public {
        uint requiredAmount = rewardCategory;
        require(balanceOf(msg.sender) >= requiredAmount, "Insufficient Amount");
        burn(requiredAmount);
        emit RedeemToken(msg.sender, rewardCategory);
    }
```

- This function allows players to burn their tokens. 
```solidity
    function burn(uint amount) public {
        _burn(msg.sender, amount);
        emit BurnToken(msg.sender, amount);
    }
}
```
