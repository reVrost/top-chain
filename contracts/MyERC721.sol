// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Base64.sol";
import "@imtbl/zkevm-contracts/contracts/token/erc721/ImmutableERC721Preset.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract MyERC721 is ImmutableERC721Preset {
    mapping(uint256 => string) private _tokenIdToString;

    constructor(
        address owner,
        string memory name,
        string memory symbol,
        string memory baseURI,
        string memory contractURI
    ) ImmutableERC721Preset(owner, name, symbol, baseURI, contractURI) {}



//    function train(uint256 tokenId) public {
//        require(_exists(tokenId), "Please use an existing token");
//        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
//        uint256 currentLevel = tokenIdToLevels[tokenId];
//        tokenIdToLevels[tokenId] = currentLevel + 1;
//        _setTokenURI(tokenId, getTokenURI(tokenId));
//    }

//    function generateCharacter(uint256 tokenId) public returns (string memory){
//        bytes memory svg = abi.encodePacked(
//            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
//            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
//            '<rect width="100%" height="100%" fill="black" />',
//            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Warrior", '</text>',
//            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ", getLevels(tokenId), '</text>',
//            '</svg>'
//        );
//        return string(
//            abi.encodePacked(
//                "data:image/svg+xml;base64,",
//                Base64.encode(svg)
//            )
//        );
//    }

    /// extend
    function permissionedMint2(address to, string memory metadata)  external onlyRole(MINTER_ROLE)   returns (uint256)
    {
        uint256 tokenId =  super._mintNextToken(to);
        _tokenIdToString[tokenId] = metadata;
        return tokenId;
    }
  /// extend
    function permissionedMint3(address to, string memory desc, string memory imageData)  external onlyRole(MINTER_ROLE)   returns (uint256)
    {

        uint256 tokenId =  super._mintNextToken(to);

        bytes memory dataURI = abi.encodePacked(
            '{',
            '"name": "Top chain #', Strings.toString(tokenId), '",',
            '"description": "Battles on chain",',
            '"image": "', imageData, '"',
            '}'
        );
        string memory  md =  string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
        _tokenIdToString[tokenId] = md;
        return tokenId;
    }

    function  getMetadataOf(uint256 tokenId) public view  returns (string memory) {
//        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _tokenIdToString[tokenId];
    }
}




