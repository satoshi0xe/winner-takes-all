// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract WinnerTakesAll {
    struct Investor {
        address investor;
        uint256 amount;
    }

    uint256 timer;

    mapping(address => Investor) listOfInvestors;

    uint256 investment;

    // Funding threshold to be reached
    uint256 immutable TARGET_AMOUNT = 0.5 ether;

    // Investor this largest investment
    mapping(address => uint) topInvestor;

    function invest() external payable onlyInvestor {
        // Check if amount is greater than 0
        require(msg.value >= TARGET_AMOUNT, "Invest more!");

        uint256 amountToInvest = msg.value;

        investment += amountToInvest;
        listOfInvestors[msg.sender].amount += amountToInvest;
    }

    function join() public {
        require(
            listOfInvestors[msg.sender].investor != msg.sender,
            "You're already joined the round!"
        );

        listOfInvestors[msg.sender].investor = msg.sender;
    }

    function getInvestment() public view returns (uint256) {
        return (investment / 1 ether);
    }

    modifier onlyInvestor() {
        Investor memory investor = listOfInvestors[msg.sender];

        require(investor.investor == msg.sender, "You are not an investor !");
        _;
    }
}
