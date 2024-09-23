//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {

    FundMe fundMe;

    address USER = makeAddr("USER");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    // uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); //give user moneh
    }

    modifier funded() {
        vm.prank(USER); //the next tx will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testUserCanFundInteractions() public funded{
        // FundFundMe fundFundMe = new FundFundMe();
        // fundFundMe.fundFundMe(address(fundMe));

        // address funder = fundMe.getFunders(0);
        // assertEq(funder, USER);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0 ether);
        console.log(address(fundMe).balance);
    }
}