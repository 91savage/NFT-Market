// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

 
// ERC721URIStorage : tokenURI를 관리하는 컨트랙트, 이미지 등을 저장하는 JSON객체를 tokenURI로 관리함.
// Ownable : 컨트랙트의 소유권을 관리, NFT를 민팅하는 경우 컨트랙트 소유한 계정만 발행하도록 함,
//  소유주만 접근하도록 하기위해 onlyOwner Modifier를 함수에 사용
contract MintNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    // Counters.Counter를 사용해서 _tokenIds값을 추적한다. NFT가 발행되면 _tokenIds를 1증가시키면서 발행된 NFT에 id를 부여함.
    // Counter는 uint256 값을 갖고, current(), increment(), decrement(), reset() 함수를 이용해서 값을 다룸.
    Counters.Counter private _tokenIds;

    // 생성자로 ERC721을 그대로 호출함, 첫번쨰 인자는 토큰이름, 두번째 인자는 심볼
    constructor() public ERC721("ArtNFT", "ART"){}

    // NFT 발행 함수, NFT json(이름, 설명, 이미지URI, 속성 등등) 을 담고 있는 tokenURI를 파라미터로 전달.
    function mintNFT(string memory toeknURI) public onlyOwner returns(uint256){
        // NFT를 발행하면 발행된 토큰의 개수를 추적하는 tokenIds값을 1 즐가시킴,
        _tokenIds.increment();
        // 동시에 현재 발행하는 NFT의 토큰 ID로 할당 (앞서 1 증가시킨 현재 tokenI
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, toeknURI);

        return newItemId;
    }
}
