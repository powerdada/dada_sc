pragma solidity ^0.4.2;

/**
 * This contract handles the actions for every collectible on DADA...
 */
contract DadaCollectible {
  
  address owner;

  // starts turned off to prepare the drawings before going public
  bool isExecutionAllowed = false;

  struct Offer {
      bool isForSale;
      uint drawingId;
      uint printIndex;
      address seller;
      uint minValue;          // in ether
      address onlySellTo;     // specify to sell only to a specific person
      uint lastSellValue;
  }

  struct Bid {
      bool hasBid;
      uint drawingId;
      uint printIndex;
      address bidder;
      uint value;
  }

  struct Collectible{
    uint drawingId;
    string name;
    uint totalSupply;
    uint nextPrintIndexToAssign;
    bool allPrintsAssigned;
    uint initialPrice;
    // the key is the printIndex expressed by uint
    // the value is the user who owns that specific print expressed by the address
    mapping (uint => address) printIndexToAddress;
    /* This creates an array with all balances */
    mapping (address => uint) balanceOf;
    // A record of collectibles that are offered for sale at a specific minimum value, 
    // and perhaps to a specific person, the key to access and offer is the printIndex
    // since every single offer inside the Collectible struct will be tied to the main
    // drawingId that identifies that collectible.
    mapping (uint => Offer) OfferedForSale;
    // A record of the highest collectible bid, the key to access a bid 
    // is the printIndex since every single offer inside the Collectible struct 
    // will be tied to the main drawingId that identifies that collectible.
    mapping (uint => Bid) Bids;
  }    
  
  // "Hash" list of the different Collectibles available in gallery
  mapping (uint => Collectible) public drawingIdToCollectibles;

  mapping (address => uint) public pendingWithdrawals;

  event Assigned(address indexed to, uint256 collectibleIndex, uint256 printIndex);
  event Transfered(address indexed from, address indexed to, uint256 value);
  event CollectibleTransfered(address indexed from, address indexed to, uint256 collectibleIndex, uint256 printIndex);
  event CollectibleOffered(uint indexed collectibleIndex, uint indexed printIndex, uint minValue, address indexed toAddress);
  event CollectibleBidEntered(uint indexed collectibleIndex, uint indexed printIndex, uint value, address indexed fromAddress);
  event CollectibleBidWithdrawn(uint indexed collectibleIndex, uint indexed printIndex, uint value, address indexed fromAddress);
  event CollectibleBought(uint indexed collectibleIndex, uint printIndex, uint value, address indexed fromAddress, address indexed toAddress);
  event CollectibleNoLongerForSale(uint indexed collectibleIndex, uint indexed printIndex);

  // The constructor is executed only when the contract is created in the blockchain.
  function DadaCollectible () { //payable?
    // assigns the address of the account creating the contract as the 
    // "owner" of the contract. Since the contract doesn't have 
    // a "set" function for the owner attribute this value will be immutable. 
    owner = msg.sender;
    // Collectible(drawingId, name, totalSupply, 
    //  nextPrintIndexToAssign, allPrintsAssigned,initialPrice);
    drawingIdToCollectibles[766] = Collectible(766,'Something',5,0,false,100);
    drawingIdToCollectibles[765] = Collectible(765,'Something else',5,0,false,100);
    drawingIdToCollectibles[764] = Collectible(764,'Nothing',10,0,false,20);
  }

  // main business logic functions

  // buyer's functions
  function buyCollectible(uint drawingId, uint printIndex) payable {
    require(isExecutionAllowed);
    // requires the drawing id to actually exist
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply);
    Offer storage offer = collectible.OfferedForSale[printIndex];
    require(offer.drawingId != 0);
    require(offer.isForSale); // drawing actually for sale
    require (offer.onlySellTo == 0x0 || offer.onlySellTo == msg.sender);  // drawing can be sold to this user
    require(msg.value >= offer.minValue); // Didn't send enough ETH
    require(offer.seller == collectible.printIndexToAddress[printIndex]); // Seller still owner of the drawing

    address seller = offer.seller;
    address buyer = msg.sender;

    collectible.printIndexToAddress[printIndex] = buyer; // "gives" the print to the buyer
    // decrease by one the amount of prints the seller has of this particullar drawing
    collectible.balanceOf[buyer]--;
    // increase by one the amount of prints the buyer has of this particullar drawing
    collectible.balanceOf[msg.sender]++;

    // launch the Transfered event
    Transfered(seller, buyer, 1);

    makeCollectibleUnavailableToSale(drawingId, printIndex);
    pendingWithdrawals[seller] += msg.value;
    // launch the CollectibleBought event    
    CollectibleBought(drawingId, printIndex, msg.value, seller, buyer);

    // Check for the case where there is a bid from the new owner and refund it.
    // Any other bid can stay in place.
    Bid storage bid = collectible.Bids[printIndex];
    if (bid.bidder == buyer) {
      // Kill bid and refund value
      pendingWithdrawals[buyer] += bid.value;
      collectible.Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    }
  }

  function enterBidForCollectible(uint drawingId, uint printIndex) payable {
    require(isExecutionAllowed);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] != 0x0); // Print is owned by somebody
    require(collectible.printIndexToAddress[printIndex] != msg.sender); // Print is not owned by bidder
    require(printIndex < collectible.totalSupply);
    // require(collectible.allPrintsAssigned);            

    require(msg.value > 0); // Bid must be greater than 0
    // get the current bid for that print if any
    Bid storage existing = collectible.Bids[printIndex];
    // Must outbid previous bid by at least 5%. Apparently is not possible to 
    // multiply by 1.05, that's why we do it manually.
    require(msg.value >= existing.value+(existing.value*5/100));
    if (existing.value > 0) {
        // Refund the failing bid from the previous bidder
        pendingWithdrawals[existing.bidder] += existing.value;
    }
    // add the new bid
    collectible.Bids[printIndex] = Bid(true, collectible.drawingId, printIndex, msg.sender, msg.value);
    CollectibleBidEntered(collectible.drawingId, printIndex, msg.value, msg.sender);
  }

  // used by a user who wants to cancell a bid placed by her/him
  function withdrawBidForCollectible(uint drawingId, uint printIndex) {
    require(isExecutionAllowed);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply);
    // require(collectible.allPrintsAssigned);
    require(collectible.printIndexToAddress[printIndex] != 0x0); // Print is owned by somebody
    require(collectible.printIndexToAddress[printIndex] != msg.sender); // Print is not owned by bidder
    Bid storage bid = collectible.Bids[printIndex];
    require(bid.bidder == msg.sender);
    CollectibleBidWithdrawn(drawingId, printIndex, bid.value, msg.sender);

    uint amount = bid.value;
    collectible.Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    // Refund the bid money
    msg.sender.transfer(amount);
  }

  // seller's functions
  function offerCollectibleForSale(uint drawingId, uint printIndex, uint minSalePriceInWei) {
    require(isExecutionAllowed);
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);

    collectible.OfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, 0x0);
    CollectibleOffered(drawingId, printIndex, minSalePriceInWei, 0x0);
  }

  function offerCollectibleForSaleToAddress(uint drawingId, uint printIndex, uint minSalePriceInWei, address toAddress) {
    require(isExecutionAllowed);
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);

    collectible.OfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, toAddress);
    CollectibleOffered(drawingId, printIndex, minSalePriceInWei, toAddress);
  }

  function acceptBidForCollectible(uint drawingId, uint printIndex, uint minPrice) {
    require(isExecutionAllowed);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply);
    // require(collectible.allPrintsAssigned);                
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    address seller = msg.sender;

    Bid storage bid = collectible.Bids[printIndex];
    require(bid.value > 0); // Will be zero if there is no actual bid
    require(bid.value >= minPrice); // Prevent a condition where a bid is withdrawn and replaced with a lower bid but seller doesn't know

    collectible.printIndexToAddress[printIndex] = bid.bidder;
    collectible.balanceOf[seller]--;
    collectible.balanceOf[bid.bidder]++;
    Transfered(seller, bid.bidder, 1);

    collectible.OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, bid.bidder, 0, 0x0);
    uint amount = bid.value;
    CollectibleBought(collectible.drawingId, printIndex, bid.value, seller, bid.bidder);
    collectible.Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    pendingWithdrawals[seller] += amount;
  }

  // used by a user who wants to cashout his money
  function withdraw() {
    require(isExecutionAllowed);
    // require(collectible.allPrintsAssigned);
    uint amount = pendingWithdrawals[msg.sender];
    // Remember to zero the pending refund before
    // sending to prevent re-entrancy attacks
    pendingWithdrawals[msg.sender] = 0;
    msg.sender.transfer(amount);
  }

  // Transfer ownership of a punk to another user without requiring payment
  function transferCollectible(address to, uint drawingId, uint printIndex) {
    require(isExecutionAllowed);
    // require(collectible.allPrintsAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    // checks that the user making the transfer is the actual owner of the print
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);
    if (collectible.OfferedForSale[printIndex].isForSale) {
      makeCollectibleUnavailableToSale(drawingId, printIndex);
    }
    // sets the new owner of the print
    collectible.printIndexToAddress[printIndex] = to;
    collectible.balanceOf[msg.sender]--;
    collectible.balanceOf[to]++;
    Transfered(msg.sender, to, 1);
    CollectibleTransfered(msg.sender, to, drawingId, printIndex);
    // Check for the case where there is a bid from the new owner and refund it.
    // Any other bid can stay in place.
    Bid storage bid = collectible.Bids[printIndex];
    if (bid.bidder == to) {
      // Kill bid and refund value
      pendingWithdrawals[to] += bid.value;
      collectible.Bids[printIndex] = Bid(false, drawingId, printIndex, 0x0, 0);
    }
  }

  // utility functions
  function makeCollectibleUnavailableToSale(uint drawingId, uint printIndex) {
    require(isExecutionAllowed);
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.printIndexToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply);
    collectible.OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, msg.sender, 0, 0x0);
    // launch the CollectibleNoLongerForSale event 
    CollectibleNoLongerForSale(collectible.drawingId, printIndex);
  }

  function newCollectible(uint drawingId, uint totalSupply){
    // requires the sender to be the same address that compiled the contract,
    // this is ensured by storing the sender address
    require(owner == msg.sender);
    // requires the drawing to not exist already in the scope of the contract
    require(drawingIdToCollectibles[drawingId].drawingId == 0);
    drawingIdToCollectibles[drawingId] = Collectible(drawingId, totalSupply, 0, false, totalSupply);
  }

  function flipSwitchTo(bool state){
    require(owner == msg.sender);
    isExecutionAllowed = state;
  }


  function reserveCollectiblesForOwner(uint drawingId, uint maxForThisRun) {
    require(owner == msg.sender);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.nextPrintIndexToAssign < collectible.totalSupply);
    uint numberCollectiblesReservedThisRun = 0;
    while (collectible.nextPrintIndexToAssign < collectible.totalSupply && numberCollectiblesReservedThisRun < maxForThisRun) {
        collectible.printIndexToAddress[collectible.nextPrintIndexToAssign] = msg.sender;
        Assigned(msg.sender, drawingId, collectible.nextPrintIndexToAssign);
        numberCollectiblesReservedThisRun++;
        collectible.nextPrintIndexToAssign++;
    }
    // collectible.totalSupply -= numberCollectiblesReservedThisRun;
    //collectible.nextPrintIndexToAssign += numberCollectiblesReservedThisRun;
    collectible.balanceOf[msg.sender] += numberCollectiblesReservedThisRun;
    if(collectible.totalSupply == collectible.nextPrintIndexToAssign){
      collectible.allPrintsAssigned = true;
    }
  }

}
