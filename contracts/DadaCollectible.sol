pragma solidity ^0.4.10;

/**
 * This contract handles the actions for every collectible on DADA...
 */
contract DadaCollectible {
  
  address owner;


  struct Collectible{
    uint id;
    uint printsCap;
    // uint unit;
  }

  Collectible[] collectibles = [Collectible(123,1000), Collectible(124,500), Collectible(112,3)];

  mapping(Collectible => address) punkIndexToAddress;
  

  struct Offer {
      bool isForSale;
      uint collectibleIndex;
      address seller;
      uint minValue;          // in ether
      address onlySellTo;     // specify to sell only to a specific person
  }

  struct Bid {
      bool hasBid;
      uint collectibleIndex;
      address bidder;
      uint value;
  }

  // A record of collectibles that are offered for sale at a specific minimum value, and perhaps to a specific person
  mapping (uint => Offer) public collectiblesOfferedForSale;

  // A record of the highest collectible bid
  mapping (uint => Bid) public collectibleBids;


  event Assigned(address indexed to, uint256 collectibleIndex);
  event Transfered(address indexed from, address indexed to, uint256 value);
  event CollectibleTransfered(address indexed from, address indexed to, uint256 collectibleIndex);
  event CollectibleOffered(uint indexed collectibleIndex, uint minValue, address indexed toAddress);
  event CollectibleBidEntered(uint indexed collectibleIndex, uint value, address indexed fromAddress);
  event CollectibleBidWithdrawn(uint indexed collectibleIndex, uint value, address indexed fromAddress);
  event CollectibleBought(uint indexed collectibleIndex, uint value, address indexed fromAddress, address indexed toAddress);
  event CollectibleNoLongerForSale(uint indexed collectibleIndex);


  // The constructor is executed only when the contract is created in the blockchain.
  function DadaCollectible () {
    // assigns the address of the account creating the contract as the 
    // "owner" of the contract. Since the contract doesn't have 
    // a "set" function for the owner attribute this value will be immutable. 
    owner = msg.sender;
  }  
}
