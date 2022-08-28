// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./MintNFT.sol";

contract SaleArtToken{
    MintNFT public mintArtTokenAddress;

    //생성자 : address 주소 값 초기화함, 초기에 값을 넣어줌 (초기 셋팅이 필요 없으면 생성자 생략 가능) , 판매 할 address 등록
    constructor(address _mintArtTokenAddress){ 
        mintArtTokenAddress = MintNFT(_mintArtTokenAddress);
    }
    // 토큰아이디 입력 -> 가격
    mapping (uint256 => uint256) public artTokenPrices;
    //판매토큰 배열 생성
    uint256[] public onSaleArtTokenArray;

    function setForSaleArtToken(uint256 _artTokenId, uint256 _price) public{
        // 토큰아이디에 대한 소유자 확인.
        address artTokenOwner = mintArtTokenAddress.ownerOf(_artTokenId);

        require(artTokenOwner == msg.sender, "not owner"); // 요청자가 token 소유자인지 확인 
        require(_price > 0 , "lower price"); // price 값을 0보다 큰 값을 넣어야 함.
        require(artTokenPrices[_artTokenId]==0, "already on sale"); // token ID에 해당하는 가격이 0일 경우, 이미 판매 된 토큰으로 간주
        require(mintArtTokenAddress.isApprovedForAll(artTokenOwner,address(this)),"Art token owner did not approve token"); // 토큰 소유주 확인

        artTokenPrices[_artTokenId] = _price;

        onSaleArtTokenArray.push(_artTokenId);
    }

    function purchaseArtToken (uint256 _artTokenId) public payable {
        uint256 price = artTokenPrices[_artTokenId];
        address artTokenOwner = mintArtTokenAddress.ownerOf(_artTokenId);

        require(price > 0, "ArtToken not sale");
        require(price <= msg.value , "not money");
        require(artTokenOwner != msg.sender , "not owner");

        payable(artTokenOwner).transfer(msg.value);
        mintArtTokenAddress.safeTransferFrom(artTokenOwner,msg.sender, _artTokenId);

        artTokenPrices[_artTokenId] = 0;

        for(uint256 i=0; i<onSaleArtTokenArray.length; i++){
            if(artTokenPrices[onSaleArtTokenArray[i]] == 0){
                onSaleArtTokenArray[i] = onSaleArtTokenArray[onSaleArtTokenArray.length-1];
                onSaleArtTokenArray.pop();
            }
        }
    }

    function getonSaleArtTokenArrayLength() view public returns (uint256){
        return onSaleArtTokenArray.length;
    }
}