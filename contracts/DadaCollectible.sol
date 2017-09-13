pragma solidity ^0.4.13;

/**
 * This contract handles the actions for every collectible on DADA...
 */
contract DadaCollectible {
  
  address owner;
  // jgonzalez
  address test_owner_1 = 0x74E70E9f66A63fB157c3B3519b994e33188Fae29;
  // amilano
  address test_owner_2 = 0x520B8e6048C9603b7fee1c4953D2f04E07E42a19;
  // jcflorville
  address test_owner_3 = 0xad1e433c07d3a972bab356b760c4f6ef5bab4b76;

  address dada_account = 0x520B8e6048C9603b7fee1c4953D2f04E07E42a19;

  // starts turned off to prepare the drawings before going public
  bool isExecutionAllowed = false;

  // a wei is 0.000000000000000001 -> 1e-18;

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
    uint initialPrintIndex;
    string collectionName;
    uint authorUId; // user id at dada.nyc
    string scarcity; // denotes scarcity
  }    

  // the key is represented by the string "[drawingId]:[printIndex]" which is 
  // then converted to bytes32...
  // the value is the user who owns that specific print expressed by the address
  mapping (uint => address) public DrawingPrintToAddress;
  
  // the key is represented by the string "[drawingId]:[printIndex]" which is 
  // then converted to bytes32...
  // A record of collectibles that are offered for sale at a specific minimum value, 
  // and perhaps to a specific person, the key to access and offer is the printIndex
  // since every single offer inside the Collectible struct will be tied to the main
  // drawingId that identifies that collectible.
  mapping (uint => Offer) public OfferedForSale;

  // the key is represented by the string "[drawingId]:[printIndex]" which is 
  // then converted to bytes32...
  // A record of the highest collectible bid, the key to access a bid 
  // is the printIndex since every single offer inside the Collectible struct 
  // will be tied to the main drawingId that identifies that collectible.
  mapping (uint => Bid) public Bids;


  // "Hash" list of the different Collectibles available in gallery
  mapping (uint => Collectible) public drawingIdToCollectibles;

  mapping (address => uint) public pendingWithdrawals;

  /* This creates an array with all balances */
  mapping (address => uint) balanceOf;

  event Assigned(address indexed to, uint256 collectibleIndex, uint256 printIndex);
  event Transfered(address indexed from, address indexed to, uint256 value);
  event CollectibleTransfered(address indexed from, address indexed to, uint256 collectibleIndex, uint256 printIndex);
  event CollectibleOffered(uint indexed collectibleIndex, uint indexed printIndex, uint minValue, address indexed toAddress, uint lastSellValue);
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
    // drawingIdToCollectibles[766] = Collectible(766,'Something',5,0,false,100);
    // drawingIdToCollectibles[765] = Collectible(765,'Something else',5,0,false,100);
    // drawingIdToCollectibles[764] = Collectible(764,'Nothing',10,0,false,20);
  }

  // main business logic functions

  // buyer's functions
  function buyCollectible(uint drawingId, uint printIndex) payable {
    require(isExecutionAllowed);
    // requires the drawing id to actually exist
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    Offer storage offer = OfferedForSale[printIndex];
    require(offer.drawingId != 0);
    require(offer.isForSale); // drawing actually for sale
    require(offer.onlySellTo == 0x0 || offer.onlySellTo == msg.sender);  // drawing can be sold to this user
    require(msg.value >= offer.minValue); // Didn't send enough ETH
    require(offer.seller == DrawingPrintToAddress[printIndex]); // Seller still owner of the drawing
    require(DrawingPrintToAddress[printIndex] != msg.sender);

    address seller = offer.seller;
    address buyer = msg.sender;

    DrawingPrintToAddress[printIndex] = buyer; // "gives" the print to the buyer
    // decrease by one the amount of prints the seller has of this particullar drawing
    balanceOf[seller]--;
    // increase by one the amount of prints the buyer has of this particullar drawing
    balanceOf[buyer]++;

    // launch the Transfered event
    Transfered(seller, buyer, 1);

    // transfer ETH to the seller
    // profit delta must be equal or greater than 1e-16 to be able to divide it
    // between the involved entities (art creator -> 30%, seller -> 60% and dada -> 10%)
    // profit percentages can't be lower than 1e-18 which is the lowest unit in ETH
    // equivalent to 1 wei.
    // if(offer.lastSellValue > msg.value && (msg.value - offer.lastSellValue) >= uint(0.0000000000000001) ){ commented because we're assuming values are expressed in  "weis", adjusting in relation to that
    if(offer.lastSellValue > msg.value && (msg.value - offer.lastSellValue) >= 100 ){ // assuming 100 (weis) wich is equivalent to 1e-16
      uint profit = msg.value - offer.lastSellValue;
      // seller gets base value plus 60% of the profit
      pendingWithdrawals[seller] += offer.lastSellValue + (profit*60/100); 
      // dada gets 10% of the profit
      // pendingWithdrawals[owner] += (profit*10/100);
      // dada receives 30% of the profit to give to the artist
      // pendingWithdrawals[owner] += (profit*30/100);
      // going manual for artist and dada percentages (30 + 10)
      pendingWithdrawals[owner] += (profit*40/100);
    }else{
      // if the seller doesn't make a profit of the sell he gets the 100% of the traded
      // value.
      pendingWithdrawals[seller] += msg.value;
    }
    makeCollectibleUnavailableToSale(drawingId, printIndex, msg.value);

    // launch the CollectibleBought event    
    CollectibleBought(drawingId, printIndex, msg.value, seller, buyer);

    // Check for the case where there is a bid from the new owner and refund it.
    // Any other bid can stay in place.
    Bid storage bid = Bids[printIndex];
    if (bid.bidder == buyer) {
      // Kill bid and refund value
      pendingWithdrawals[buyer] += bid.value;
      Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    }
  }

  // buyer's functions
  function alt_buyCollectible(uint drawingId, uint printIndex) payable {
    require(isExecutionAllowed);
    // requires the drawing id to actually exist
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    Offer storage offer = OfferedForSale[printIndex];
    require(offer.drawingId == 0);
    
    // redundant?
    require(!offer.isForSale); // drawing actually for sale
    require(offer.onlySellTo == 0x0);  // onlySellTo should be "null" address (0x0) since the offer was never configured
    require(msg.value >= collectible.initialPrice); // Didn't send enough ETH
    require(offer.seller == 0x0); // Seller should be a "null" address since the offer has not been previously configured
    require(DrawingPrintToAddress[printIndex] == 0x0); // should be equal to a "null" address (0x0) since it shouldn't have an owner yet

    address seller = dada_account;
    address buyer = msg.sender;

    DrawingPrintToAddress[printIndex] = buyer; // "gives" the print to the buyer
    // decrease by one the amount of prints the seller has of this particullar drawing
    // commented while we decide what to do with balances for DADA
    // balanceOf[seller]--;
    // increase by one the amount of prints the buyer has of this particullar drawing
    balanceOf[buyer]++;

    // launch the Transfered event
    Transfered(seller, buyer, 1);

    // transfer ETH to the seller
    // profit delta must be equal or greater than 1e-16 to be able to divide it
    // between the involved entities (art creator -> 30%, seller -> 60% and dada -> 10%)
    // profit percentages can't be lower than 1e-18 which is the lowest unit in ETH
    // equivalent to 1 wei.
    // if(offer.lastSellValue > msg.value && (msg.value - offer.lastSellValue) >= uint(0.0000000000000001) ){ commented because we're assuming values are expressed in  "weis", adjusting in relation to that

    pendingWithdrawals[dada_account] += msg.value;
    
    OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, buyer, collectible.initialPrice, 0x0, collectible.initialPrice);

    // launch the CollectibleBought event    
    CollectibleBought(drawingId, printIndex, msg.value, seller, buyer);

    // Check for the case where there is a bid from the new owner and refund it.
    // Any other bid can stay in place.
    Bid storage bid = Bids[printIndex];
    if (bid.bidder == buyer) {
      // Kill bid and refund value
      pendingWithdrawals[buyer] += bid.value;
      Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    }
  }
  
  function enterBidForCollectible(uint drawingId, uint printIndex) payable {
    require(isExecutionAllowed);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(DrawingPrintToAddress[printIndex] != 0x0); // Print is owned by somebody
    require(DrawingPrintToAddress[printIndex] != msg.sender); // Print is not owned by bidder
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    // require(collectible.allPrintsAssigned);            

    require(msg.value > 0); // Bid must be greater than 0
    // get the current bid for that print if any
    Bid storage existing = Bids[printIndex];
    // Must outbid previous bid by at least 5%. Apparently is not possible to 
    // multiply by 1.05, that's why we do it manually.
    require(msg.value >= existing.value+(existing.value*5/100));
    if (existing.value > 0) {
        // Refund the failing bid from the previous bidder
        pendingWithdrawals[existing.bidder] += existing.value;
    }
    // add the new bid
    Bids[printIndex] = Bid(true, collectible.drawingId, printIndex, msg.sender, msg.value);
    CollectibleBidEntered(collectible.drawingId, printIndex, msg.value, msg.sender);
  }

  // used by a user who wants to cancell a bid placed by her/him
  function withdrawBidForCollectible(uint drawingId, uint printIndex) {
    require(isExecutionAllowed);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    // require(collectible.allPrintsAssigned);
    require(DrawingPrintToAddress[printIndex] != 0x0); // Print is owned by somebody
    require(DrawingPrintToAddress[printIndex] != msg.sender); // Print is not owned by bidder
    Bid storage bid = Bids[printIndex];
    require(bid.bidder == msg.sender);
    CollectibleBidWithdrawn(drawingId, printIndex, bid.value, msg.sender);

    uint amount = bid.value;
    Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
    // Refund the bid money
    msg.sender.transfer(amount);
  }

  // seller's functions
  function offerCollectibleForSale(uint drawingId, uint printIndex, uint minSalePriceInWei) {
    require(isExecutionAllowed);
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(DrawingPrintToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    uint lastSellValue = OfferedForSale[printIndex].lastSellValue;
    OfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, 0x0, lastSellValue);
    CollectibleOffered(drawingId, printIndex, minSalePriceInWei, 0x0, lastSellValue);
  }

  function offerCollectibleForSaleToAddress(uint drawingId, uint printIndex, uint minSalePriceInWei, address toAddress) {
    require(isExecutionAllowed);
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(DrawingPrintToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    uint lastSellValue = OfferedForSale[printIndex].lastSellValue;
    OfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, toAddress, lastSellValue);
    CollectibleOffered(drawingId, printIndex, minSalePriceInWei, toAddress, lastSellValue);
  }

  function acceptBidForCollectible(uint drawingId, uint printIndex, uint minPrice) {
    require(isExecutionAllowed);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    // require(collectible.allPrintsAssigned);
    require(DrawingPrintToAddress[printIndex] == msg.sender);
    address seller = msg.sender;

    Bid storage bid = Bids[printIndex];
    require(bid.value > 0); // Will be zero if there is no actual bid
    require(bid.value >= minPrice); // Prevent a condition where a bid is withdrawn and replaced with a lower bid but seller doesn't know

    DrawingPrintToAddress[printIndex] = bid.bidder;
    balanceOf[seller]--;
    balanceOf[bid.bidder]++;
    Transfered(seller, bid.bidder, 1);
    uint amount = bid.value;

    Offer storage offer = OfferedForSale[printIndex];
    // transfer ETH to the seller
    // profit delta must be equal or greater than 1e-16 to be able to divide it
    // between the involved entities (art creator -> 30%, seller -> 60% and dada -> 10%)
    // profit percentages can't be lower than 1e-18 which is the lowest unit in ETH
    // equivalent to 1 wei.
    // if(offer.lastSellValue > msg.value && (msg.value - offer.lastSellValue) >= uint(0.0000000000000001) ){ commented because we're assuming values are expressed in  "weis", adjusting in relation to that
    if(offer.lastSellValue > amount && (amount - offer.lastSellValue) >= 100 ){ // assuming 100 (weis) wich is equivalent to 1e-16
      uint profit = amount - offer.lastSellValue;
      // seller gets base value plus 60% of the profit
      pendingWithdrawals[seller] += offer.lastSellValue + (profit*60/100); 
      // dada gets 10% of the profit
      pendingWithdrawals[owner] += (profit*10/100);
      // dada receives 30% of the profit to give to the artist
      pendingWithdrawals[owner] += (profit*30/100);
    }else{
      // if the seller doesn't make a profit of the sell he gets the 100% of the traded
      // value.
      pendingWithdrawals[seller] += amount;
    }
    // does the same as the function makeCollectibleUnavailableToSale
    OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, bid.bidder, 0, 0x0, amount);
    CollectibleBought(collectible.drawingId, printIndex, bid.value, seller, bid.bidder);
    Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);

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
    require(DrawingPrintToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    if (OfferedForSale[printIndex].isForSale) {
      makeCollectibleUnavailableToSale(drawingId, printIndex, OfferedForSale[printIndex].lastSellValue);
    }
    // sets the new owner of the print
    DrawingPrintToAddress[printIndex] = to;
    balanceOf[msg.sender]--;
    balanceOf[to]++;
    Transfered(msg.sender, to, 1);
    CollectibleTransfered(msg.sender, to, drawingId, printIndex);
    // Check for the case where there is a bid from the new owner and refund it.
    // Any other bid can stay in place.
    Bid storage bid = Bids[printIndex];
    if (bid.bidder == to) {
      // Kill bid and refund value
      pendingWithdrawals[to] += bid.value;
      Bids[printIndex] = Bid(false, drawingId, printIndex, 0x0, 0);
    }
  }

  // utility functions
  function makeCollectibleUnavailableToSale(uint drawingId, uint printIndex, uint lastSellValue) {
    require(isExecutionAllowed);
    // require(allCollectiblesAssigned);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(DrawingPrintToAddress[printIndex] == msg.sender);
    require(printIndex < collectible.totalSupply+collectible.initialPrintIndex);
    OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, msg.sender, 0, 0x0, lastSellValue);
    // launch the CollectibleNoLongerForSale event 
    CollectibleNoLongerForSale(collectible.drawingId, printIndex);
  }

  function newCollectible(uint drawingId, string name, uint totalSupply, uint initialPrice, uint initialPrintIndex){
    // requires the sender to be the same address that compiled the contract,
    // this is ensured by storing the sender address
    // require(owner == msg.sender);
    require(test_owner_1 == msg.sender || test_owner_2 == msg.sender || test_owner_3 == msg.sender);
    // requires the drawing to not exist already in the scope of the contract
    require(drawingIdToCollectibles[drawingId].drawingId == 0);
    drawingIdToCollectibles[drawingId] = Collectible(drawingId, name, totalSupply, initialPrintIndex, false, initialPrice, initialPrintIndex);
  }

  function flipSwitchTo(bool state){
    // require(owner == msg.sender);
    require(test_owner_1 == msg.sender || test_owner_2 == msg.sender || test_owner_3 == msg.sender);
    isExecutionAllowed = state;
  }


  function reserveCollectiblesForOwner(uint drawingId, uint maxForThisRun) {
    // require(owner == msg.sender);
    require(test_owner_1 == msg.sender || test_owner_2 == msg.sender || test_owner_3 == msg.sender);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    Collectible storage collectible = drawingIdToCollectibles[drawingId];
    require(collectible.nextPrintIndexToAssign < collectible.totalSupply+collectible.initialPrintIndex);
    uint numberCollectiblesReservedThisRun = 0;
    while (collectible.nextPrintIndexToAssign < collectible.totalSupply+collectible.initialPrintIndex && numberCollectiblesReservedThisRun < maxForThisRun) {
        // assigns the the owner of the contract as the owner of the print
        DrawingPrintToAddress[collectible.nextPrintIndexToAssign] = msg.sender;
        // creates the first offer of the print
        OfferedForSale[collectible.nextPrintIndexToAssign] = Offer(true, collectible.drawingId, collectible.nextPrintIndexToAssign, msg.sender, collectible.initialPrice, 0x0, collectible.initialPrice);
        Assigned(msg.sender, drawingId, collectible.nextPrintIndexToAssign);
        numberCollectiblesReservedThisRun++;
        collectible.nextPrintIndexToAssign++;
    }
    balanceOf[msg.sender] += numberCollectiblesReservedThisRun;
    if(collectible.totalSupply+collectible.initialPrintIndex == collectible.nextPrintIndexToAssign){
      collectible.allPrintsAssigned = true;
    }
  }

  function markAllPrintsAssigned(uint drawingId){
    require(test_owner_1 == msg.sender || test_owner_2 == msg.sender || test_owner_3 == msg.sender);
    require(drawingIdToCollectibles[drawingId].drawingId != 0);
    drawingIdToCollectibles[drawingId].allPrintsAssigned = true;
  }
  
  // function getDrawingsByAccount(address owner) public returns(uint[]){

  // } 

  // // converts uint into string
  // function uintToString(uint v) internal returns (string) {
  //   uint maxlength = 100;
  //   bytes memory reversed = new bytes(maxlength);
  //   uint i = 0;
  //   while (v != 0) {
  //       uint remainder = v % 10;
  //       v = v / 10;
  //       reversed[i++] = byte(48 + remainder);
  //   }
  //   bytes memory s = new bytes(i + 1);
  //   for (uint j = 0; j <= i; j++) {
  //       s[j] = reversed[i - j];
  //   }
  //   return string(s);
  // }
  // function strConcat(string _a, string _b) internal returns (string){
  //   bytes memory _ba = bytes(_a);
  //   bytes memory _bb = bytes(_b);
  //   string memory ab = new string(_ba.length + _bb.length);
  //   bytes memory bab = bytes(ab);
  //   uint k = 0;
  //   for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
  //   for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
  //   return string(bab);
  // }  
  // function stringToBytes32(string key) internal returns (bytes32 ret) {
  //   require(bytes(key).length <= 32);

  //   assembly {
  //     ret := mload(add(key, 32))
  //   }
  // } 
}
