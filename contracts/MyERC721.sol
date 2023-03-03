// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Base64.sol";
import "@imtbl/zkevm-contracts/contracts/token/erc721/ImmutableERC721Preset.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract MyERC721 is ImmutableERC721Preset {
    mapping(uint256 => string) private _tokenIdToString;
    mapping(uint256 => bool) private _takenSeeds;

    constructor(
        address owner,
        string memory name,
        string memory symbol,
        string memory baseURI,
        string memory contractURI
    ) ImmutableERC721Preset(owner, name, symbol, baseURI, contractURI) {}

    function permissionedMintWithMetadata(address to, string memory desc) payable external onlyRole(MINTER_ROLE) returns (uint256)
    {
        require(msg.value > 0, "Must be willing to burn ETH to get a Top Chain NFT");
        require(_takenSeeds[msg.value] == false, "Seed already taken, pick a different burn amount");

        _takenSeeds[msg.value] = true;

        // Let it burn!!
        payable(address(0)).transfer(msg.value);

        // Get the new tokenId
        uint256 tokenId =  super._mintNextToken(to);

        // Get the svg data
        string memory svg = _renderFromSeed(msg.value);

        bytes memory dataURI = abi.encodePacked(
            '{',
            '"name": "Top chain #', Strings.toString(tokenId), '",',
            '"description":"', desc, '",'
            '"image": "', svg, '"',
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

    function _renderFromSeed(uint256 burntWei) public returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 200 200">',
            '<defs> <linearGradient id="Gradient1"> <stop class="stop1" offset="0%" /> <stop class="stop2" offset="50%" /> <stop class="stop3" offset="100%" /> </linearGradient>',
            '<linearGradient id="Gradient2" x1="0" x2="0" y1="0" y2="1"><stop offset="0%" stop-color="pink" /><stop offset="50%" stop-color="black" stop-opacity="0" /> <stop offset="100%" stop-color="blue" /></linearGradient>',
            '<style> <![CDATA[#rect1 { fill: url(#Gradient1); }.stop1 { stop-color: pink; }.stop2 { stop-color: black; stop-opacity: 0; }.stop3 { stop-color: blue; }]]> </style></defs>',
             '<rect width="200px" height="200px" fill="url(#Gradient2)"/>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Welcome Top Chainer",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "You burnt: ",Strings.toString(burntWei),'wei</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',"WHAT A HERO",'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }
}