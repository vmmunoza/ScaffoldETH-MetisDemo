// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract YourContract is Ownable, Pausable, ReentrancyGuard {
    // State Variables
    string public greeting = "Building Unstoppable Apps!!!";
    uint256 public totalCounter = 0;
    bool public premium = false;

    mapping(address => uint256) public userGreetingCounter;
    mapping(address => uint256) public userNumbers;

    struct GreetingLog {
        string message;
        uint256 timestamp;
    }

    mapping(address => GreetingLog[]) public greetingHistory;

    // Events
    event GreetingChange(address indexed greetingSetter, string newGreeting, bool premium, uint256 value);
    event CounterReset();
    event NumberUpdated(address indexed user, uint number);

    // Constructor (inherits Ownable)
    constructor() Ownable() {}

    // Main greeting setter
    function setGreeting(string memory _newGreeting) public payable whenNotPaused nonReentrant {
        console.log("Setting new greeting '%s' from %s", _newGreeting, msg.sender);

        greeting = _newGreeting;
        totalCounter += 1;
        userGreetingCounter[msg.sender] += 1;

        if (msg.value > 0) {
            premium = true;
        } else {
            premium = false;
        }

        // Store greeting history
        greetingHistory[msg.sender].push(GreetingLog(_newGreeting, block.timestamp));

        emit GreetingChange(msg.sender, _newGreeting, premium, msg.value);
    }

    function resetCounter() public onlyOwner {
        totalCounter = 0;
        emit CounterReset();
    }

    function storeNumber(uint256 _number) public whenNotPaused {
        userNumbers[msg.sender] = _number;
        emit NumberUpdated(msg.sender, _number);
    }

    function getUserGreetingHistory(address user) public view returns (GreetingLog[] memory) {
        return greetingHistory[user];
    }

    // Admin: Withdraw funds (reentrancy protected)
    function withdraw() public onlyOwner nonReentrant {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }

    // Emergency pause/unpause
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // Accept ETH
    receive() external payable {}
}
