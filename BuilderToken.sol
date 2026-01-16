// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BuilderToken {
    string public name = "Base Builder Coin";
    string public symbol = "BBC";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Track if someone has already claimed
    mapping(address => bool) public hasClaimed;

    // --- MAIN INTERACTION FUNCTION ---
    
    // Anyone can call this function once to get 1,000 free tokens!
    function mintFreeTokens() public {
        require(!hasClaimed[msg.sender], "You have already claimed your tokens!");
        
        uint256 amount = 1000 * (10 ** decimals); // 1,000 tokens
        
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        hasClaimed[msg.sender] = true;
        
        emit Transfer(address(0), msg.sender, amount);
    }

    // --- STANDARD ERC-20 FUNCTIONS (Required for Wallets to see the token) ---

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}