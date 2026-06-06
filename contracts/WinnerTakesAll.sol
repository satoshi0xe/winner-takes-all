// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {console} from "forge-std/console.sol";

error NotOwner();

contract WinnerTakesAll {
    struct Investor {
        uint32 index;
        uint256 amount;
    }

    uint256 timer;

    address[] public listOfInvestors;

    uint256 investment;

    mapping(address => Investor) public investors;

    // Funding threshold to be reached
    uint256 immutable TARGET_AMOUNT = 0.5 ether;

    // Investor this largest investment
    address public topInvestor;

    function invest() external payable onlyInvestor {
        // Check if amount is greater than 0
        require(msg.value >= TARGET_AMOUNT, "Invest more!");

        uint256 amountToInvest = msg.value;

        investment += amountToInvest;
        investors[msg.sender].amount += amountToInvest;
    }

    function join() public {
        // Retrieve current investor index
        uint32 investorIndex = investors[msg.sender].index;

        if (listOfInvestors.length == 0) {
            listOfInvestors.push(msg.sender);
            return;
        }

        // Prevent to join if already investor
        require(
            listOfInvestors[investorIndex] != msg.sender,
            "You're already joined the round!"
        );
    }

    function getTotalInvestment() public view onlyInvestor returns (uint256) {
        return (investment / 1 ether);
    }

    function myInvestment() public view onlyInvestor returns (uint256) {
        return (investors[msg.sender].amount / 1 ether);
    }

    function setTopInvestor() internal {}

    modifier onlyInvestor() {
        Investor memory investor = investors[msg.sender];

        uint32 investorIndex = investor.index;

        if (listOfInvestors.length == 0) {
            revert("You are not an investor !");
        }

        require(
            listOfInvestors[investorIndex] == msg.sender,
            "You are not an investor !"
        );
        _;
    }
}
