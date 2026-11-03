//SPDX-License-Identifier:MIT
pragma solidity ^0.8.34;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";

contract BasicNFTtest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNFT;
    address public USER = makeAddr("user");
    string public constant TOY_POM = "ipfs://bafkreihmp2sv6fojjzliornxg52o7yzufvq3tdu5jf7ynohqyf5c66lare.json";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        bytes memory expectedName = abi.encodePacked("Doggy");
        bytes32 expectedNameHash = keccak256(expectedName);
        bytes memory actualName = abi.encodePacked(basicNFT.name());
        bytes32 actualNameHash = keccak256(actualName);
        assertEq(expectedNameHash, actualNameHash);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNFT.mintNft(TOY_POM);

        assert(basicNFT.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(TOY_POM)) == keccak256(abi.encodePacked(basicNFT.tokenURI(0))));
    }
}
