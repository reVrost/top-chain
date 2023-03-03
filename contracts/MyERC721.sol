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

    function permissionedMintWithMetadata(address to, string memory desc, string memory imageData)  external onlyRole(MINTER_ROLE)   returns (uint256)
    {

        uint256 tokenId =  super._mintNextToken(to);

        bytes memory dataURI = abi.encodePacked(
            '{',
            '"name": "Top chain #', Strings.toString(tokenId), '",',
            '"description":"', desc, '",'
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
        return _tokenIdToString[tokenId];
    }
    
    // function getMostRecentTokenID() returns (uint256) {
    //     return super.nextTokenId.current();
    // }
}




