DADA Smart Contract v1.0
====

# Versions
1. `Truffle v3.4.8 (core: 3.4.8)`
2. `Solidity v0.4.15 (solc-js)`

# Truffle Commands
All commands should be executed in the project folder

### Compile/Migrate 
`truffel migrate`

### Truffle Console
`truffle console`

# Web 3 Commands
## Example
1. Create new Collectible
```DADA_ETHER.DadaCollectibleContract.newCollectible(471,"First",10,1,1000,function(error,result){console.log(result);})```

2. Reserve Collectible
```DADA_ETHER.DadaCollectibleContract.reserveCollectiblesForOwner(471,10,function(error,response){console.log(response);})```

3. Flip Switch
```DADA_ETHER.DadaCollectibleContract.flipSwitchTo(true,function(error,response){console.log(response);})```

4. Witdraw
```DADA_ETHER.DadaCollectibleContract.withdraw(function(error,response){console.log(response);})```
