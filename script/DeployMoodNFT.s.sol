//SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Script, console} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

contract DeployMoodNFT is Script {
    function run() external returns (MoodNFT) {
        string memory LazySvg = vm.readFile("./img/lazy_dragon.svg");
        string memory AngrySvg = vm.readFile("./img/angry_dragon.svg");

        vm.startBroadcast();
        MoodNFT moodnft = new MoodNFT(
            svgToImageURI(LazySvg),
            svgToImageURI(AngrySvg)
        );
        vm.stopBroadcast();
        return moodnft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
