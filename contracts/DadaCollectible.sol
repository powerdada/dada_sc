pragma solidity ^0.4.10;

/**
 * This contract handles the actions for every collectible on DADA...
 */
contract DadaCollectible {
  
  address owner;

  struct Offer {
      bool isForSale;
      uint drawingId;
      uint collectiblePrintIndex;
      address seller;
      uint minValue;          // in ether
      address onlySellTo;     // specify to sell only to a specific person
  }

  struct Bid {
      bool hasBid;
      uint drawingId;
      uint collectiblePrintIndex;
      address bidder;
      uint value;
  }

  struct Collectible{
    uint drawingId;
    uint totalSupply;
    uint nextDrawingIndexToAssign;
    bool allPrintsAssigned;
    uint printsRemainingToAssign;
    // the key is the printIndex expressed by uint
    // the value is the user who owns that specific print expressed by the address
    mapping (uint => address) printIndexToAddress;
    /* This creates an array with all balances */
    mapping (address => uint) balanceOf;
    // A record of collectibles that are offered for sale at a specific minimum value, 
    // and perhaps to a specific person, the key to access and offer is the printIndex
    // since every single offer inside the Collectible struct will be tied to the main
    // drawingId that identifies that collectible.
    mapping (uint => Offer) collectiblesOfferedForSale;
    // A record of the highest collectible bid, the key to access a bid 
    // is the printIndex since every single offer inside the Collectible struct 
    // will be tied to the main drawingId that identifies that collectible.
    mapping (uint => Bid) collectibleBids;
  }    
  
  // "Hash" list of the different Collectibles available in gallery
  mapping (uint => Collectible) public drawingIdToCollectibles;

  mapping (address => uint) public pendingWithdrawals;

  event Assigned(address indexed to, uint256 collectibleIndex);
  event Transfered(address indexed from, address indexed to, uint256 value);
  event CollectibleTransfered(address indexed from, address indexed to, uint256 collectibleIndex);
  event CollectibleOffered(uint indexed collectibleIndex, uint indexed printIndex, uint minValue, address indexed toAddress);
  event CollectibleBidEntered(uint indexed collectibleIndex, uint value, address indexed fromAddress);
  event CollectibleBidWithdrawn(uint indexed collectibleIndex, uint value, address indexed fromAddress);
  event CollectibleBought(uint indexed collectibleIndex, uint printIndex, uint value, address indexed fromAddress, address indexed toAddress);
  event CollectibleNoLongerForSale(uint indexed collectibleIndex, uint indexed printIndex);


  // The constructor is executed only when the contract is created in the blockchain.
  function DadaCollectible () { //payable?
    // assigns the address of the account creating the contract as the 
    // "owner" of the contract. Since the contract doesn't have 
    // a "set" function for the owner attribute this value will be immutable. 
    owner = msg.sender;

    drawingIdToCollectibles[123] = Collectible(123,1000,0,false,1000);
    drawingIdToCollectibles[124] = Collectible(124,500,0,false,500);
    drawingIdToCollectibles[112] = Collectible(112,3,0,false,3);
  }

  function newCollectible(uint drawingId, uint totalSupply){
    // requires the sender to be the same address that compiled the contract,
    // this is ensured by storing the sender address
    require(owner == msg.sender);
    // requires the drawing to not exist already in the scope of the contract
    require(drawingIdToCollectibles[drawingId].drawingId == 0);
    drawingIdToCollectibles[drawingId] = Collectible(drawingId, totalSupply, 0, false, totalSupply);
  }

  // main business logic functions

  // buyer's functions
  function buyCollectible(uint drawingId, uint printIndex) payable {
    // requires the drawing id to actually exist
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply);
    Offer storage offer = collectible.collectiblesOfferedForSale[printIndex];
    require(offer.drawingId != 0);
    require(offer.isForSale); // drawing actually for sale
    require (offer.onlySellTo == 0x0 || offer.onlySellTo == msg.sender);  // drawing can be sold to this user
    require(msg.value >= offer.minValue); // Didn't send enough ETH
    require(offer.seller == collectible.printIndexToAddress[printIndex]); // Seller still owner of the drawing

    address seller = offer.seller;
    address buyer = msg.sender;

    collectible.printIndexToAddress[printIndex] = buyer; // "gives" the print to the buyer
    collectible.balanceOf[buyer]--;
    collectible.balanceOf[msg.sender]++;

    // launch the Transfered event
    Transfered(seller, buyer, 1);

    makeCollectibleUnavailableToSale(drawingId, printIndex);
    pendingWithdrawals[seller] += msg.value;
    // launch the CollectibleBought event    
    CollectibleBought(drawingId, printIndex, msg.value, seller, buyer);

    // Check for the case where there is a bid from the new owner and refund it.
    // Any other bid can stay in place.
    Bid storage bid = collectible.collectibleBids[printIndex];
    if (bid.bidder == buyer) {
      // Kill bid and refund value
      pendingWithdrawals[buyer] += bid.value;
      collectible.collectibleBids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    }
  }

  // seller's functions
  function offerCollectibleForSale(uint drawingId, uint printIndex, uint minSalePriceInWei) {
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);

    collectible.collectiblesOfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, 0x0);
    CollectibleOffered(drawingId, printIndex, minSalePriceInWei, 0x0);
  }

  function offerCollectibleForSaleToAddress(uint drawingId, uint printIndex, uint minSalePriceInWei, address toAddress) {
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);

    collectible.collectiblesOfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, toAddress);
    CollectibleOffered(drawingId, printIndex, minSalePriceInWei, toAddress);
  }

  // utility functions
  function makeCollectibleUnavailableToSale(uint drawingId, uint printIndex) {
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);
    collectible.collectiblesOfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, msg.sender, 0, 0x0);
    // launch the CollectibleNoLongerForSale event 
    CollectibleNoLongerForSale(collectible.drawingId, printIndex);
  }


}
