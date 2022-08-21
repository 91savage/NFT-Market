// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "MintArtToken.sol";

contract SaleArtToken {
    MintArtToken public mintArtTokenAddress;

    constructor (address _mintArtTokenAddress) {
        mintArtTokenAddress = MintArtToken(_mintArtTokenAddress);
    }

    mapping(uint256 => uint256) public artTokenPrices; // tokenId => price

    uint256[] public onSaleArtTokenArray; // 프론트앤드에서 판매중인 token 확인 

    function setForSaleArtToken(uint256 _artTokenId, uint256 _price) public {
        address artTokenOwner = mintArtTokenAddress.ownerOf(_artTokenId);

        require(artTokenOwner == msg.sender, "Caller is not Art token owner."); // 소유자가 맞는지 확인
        require(_price > 0, "Price is zero or lower."); // 0원 이상
        require(artTokenPrices[_artTokenId] == 0, "this art token is already on sale"); //판매 등록 체크
        require(mintArtTokenAddress.isApprovedForAll(artTokenOwner, address(this)), "Art token owner did not approve token."); 
        //  artTokenOwner가 address(this)에게 판매 권한을 넘겼는지 확인 (true or false)

        artTokenPrices[_artTokenId] == _price;

        onSaleArtTokenArray.push(_artTokenId);
    }

    function purchaseArtToken(uint256 _artTokenId) public payable {
        uint256 price = artTokenPrices[_artTokenId];
        address artTokenOwner = mintArtTokenAddress.ownerOf(_artTokenId);

        require(price > 0, "Art token not sale");
        require(price <= msg.value, "Caller sent lower than price."); // msg.value(eth) 가 price보다 같거나 커야 구매 가능
        require(artTokenOwner != msg.sender, " Caller is art token owner");

        payable(artTokenOwner).transfer(msg.value); // eth를 주인에게 전송
        mintArtTokenAddress.safeTransferFrom(artTokenOwner, msg.sender, _artTokenId);

        artTokenPrices[_artTokenId] == 0; // 가격초기화

        for(uint256 i=0; i<onSaleArtTokenArray.length; i++){
            if(artTokenPrices[onSaleArtTokenArray[i]] == 0) {
                onSaleArtTokenArray[i] = onSaleArtTokenArray[onSaleArtTokenArray.length -1];
                onSaleArtTokenArray.pop();
            }
        }
    }

    function getOnSaleArtTokenArrayLength() view public returns (uint256){ //판매중인 토큰의 배열의 길이 출력
    return onSaleArtTokenArray.length;
    } 
}
