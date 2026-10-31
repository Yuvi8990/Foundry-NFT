//SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

contract MoodNFT is ERC721 {
    /* Errors */
    error MoodNFT__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_lazySvgImageURI;
    string private s_angrySvgImageURI;

    enum Mood {
        Lazy,
        Angry
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory LazySvgImageURI,
        string memory AngrySvgImageURI
    ) ERC721("MoodNFT", "MN") {
        s_tokenCounter = 0;
        s_lazySvgImageURI = LazySvgImageURI;
        s_angrySvgImageURI = AngrySvgImageURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.Lazy;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isAuthorized(_ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNFT__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.Lazy) {
            s_tokenIdToMood[tokenId] = Mood.Angry;
        } else {
            s_tokenIdToMood[tokenId] = Mood.Lazy;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.Lazy) {
            imageURI = s_lazySvgImageURI;
        } else {
            imageURI = s_angrySvgImageURI;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that reflects a dragons mood.", "attributes": ',
                                '[{"trait_type": "moodiness", "value": 100}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
