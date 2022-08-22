// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MintNFT.sol";

contract SaleArtToken{
    MintNFT public mintArtTokenAddress;

    constructor(address _mintArtTokenAddress){
        mintArtTokenAddress = MintNFT(_mintArtTokenAddress);
    }

    mapping (uint256 => uint256) public artTokenPrices;
    uint256[] public onSaleArtTokenArray;

    function setForSaleArtToken(uint256 _artTokenId, uint256 _price) public{
        address artTokenOwner = mintArtTokenAddress.ownerOf(_artTokenId);

        require(artTokenOwner == msg.sender, "not owner");
        require(_price > 0 , "lower price");
        require(artTokenPrices[_artTokenId]==0, "already on sale");
        require(mintArtTokenAddress.isApprovedForAll(artTokenOwner,address(this)),"Art token owner did not approve token");

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