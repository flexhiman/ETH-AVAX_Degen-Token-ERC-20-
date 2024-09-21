// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    uint256 public constant bonusThreshold = 1000; // Bonus threshold in tokens
    uint256 public constant bonusAmount = 50;    // Bonus amount in tokens

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    event RedeemToken(address account, uint rewardCategory);
    event BurnToken(address account, uint amount);
    event TransferToken(address from, address to, uint amount);
    event BonusAwarded(address account, uint amount);

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        checkAndRewardBonus(to); // Check if the recipient is eligible for a bonus after minting
    }

    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount); // Use _transfer to handle the balance and supply changes
        checkAndRewardBonus(recipient); // Check if the recipient is eligible for a bonus
        emit TransferToken(_msgSender(), recipient, amount); // Emit Transfer event
        return true;
    }

    
    function checkAndRewardBonus(address account) internal {
        if (balanceOf(account) >= bonusThreshold) {
            _mint(account, bonusAmount); // Mint bonus tokens to the user's account
            emit BonusAwarded(account, bonusAmount); // Emit event for awarded bonus
        }
    }

    
    function getBalance() public view returns (uint){
        return balanceOf(msg.sender);
    }

    function redeem(uint rewardCategory) public {
        uint requiredAmount = rewardCategory;
        require(balanceOf(msg.sender) >= requiredAmount, "Insufficient Amount");
        burn(requiredAmount);
        emit RedeemToken(msg.sender, rewardCategory);
    }
  
    function burn(uint amount) public {
        _burn(msg.sender, amount);
        emit BurnToken(msg.sender, amount);
    }
}
