// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig helperConfig = new HelperConfig();

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTED_BALANCE = 1 ether;
    address priceFeed = helperConfig.activeNetworkConfig();


    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.run();
        vm.deal(USER, STARTED_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        // console.log(fundMe.MINIMUM_USD());
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMessageSender() public {
        console.log(fundMe.i_owner());
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testGetVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundsFailWithoutEnoughEth() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        console.log(fundMe.getAddressToAmountFunded(USER));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testRightAddressToAmountFunded() public {}
}
