// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintArtToken is ERC721Enumerable {
    constructor() ERC721("art","ART"){}

    mapping(uint256 => uint256) public artTypes;  // tokenID입력하면 arttype을 반환

    function mintArtToken() public { //아무나 이 함수를 사용 할 수 있음
        uint256 artTokenId = totalSupply() +1;  // 지금까지 민팅 된 NFT 양

        uint256 artType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, artTokenId))) % 5 + 1; //random으로 그림 뽑기

        artTypes[artTokenId] = artType;

        _mint(msg.sender, artTokenId);
    }
}