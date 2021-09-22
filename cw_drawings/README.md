# The Creeps & Weirdos Collection

Officially launched on October 31, 2017, this curated collection with a Halloween theme comprises 108 unique artworks made by 30 artists on DADA. The Creeps & Weirdos have 5 different levels of scarcity for a total of 16,600 digital editions. The levels of scarcity represent the significance of the visual conversations that the artworks belong to.

A hybrid between crypto collectibles and rare digital art, the C&W follow the tradition of the dank aesthetics and the collectible structure of the projects at the time, but they were not intended as trading cards, memes, avatars, or a game. They were conceived by DADA as a decentralized marketplace for rare digital art, paving the way for the current cryptoart marketplaces.

# The Drawings

![](https://creeps.dada.nyc/packs/media/images/Creeps_WeirdosCollection-ab88e945c7f5b6a097c6e2e33264af11.png)

The C&W artworks are truly rare because of the unique way in which they were made. Each artwork belongs to a visual conversation made on DADA, the only platform in the world where people speak to each other through drawings, creating collaborative art.

# The Artists
The artists of the Creeps & Weirdos are among the first in the world to have minted NFTs. Most of them have been in the DADA community from as early as 2014 and 2015, and are still very active today.

Artists in alphabetical order:

Adriana López, Beatriz Helena Ramos, Betunski, Boris Toledo, Boris Z. Simunich, Brian Mosch, Carlos Márquez, Cromomaniaco, DADA, Erick Sánchez, Franklin Piragauta, Gastón Spur, Hernán Cacciatore, Javier Errecarte, Jonathan Duarte, Lorena Pinasco, María García, Massel, Mauricio Rodríguez, Moxarra González, Norma Xelda Jara, Otro Captore, Raúl Ávila, Salvador Nuñez, Sebastián García, Serste, Talita Sotomayor, Thana, Thaumatropio, Vanesa Stati.

# The Contract
The C&W contract source code is verified on Etherscan:
https://etherscan.io/address/0x068696a3cf3c4676b65f1c9975dd094260109d02

It is based on the Cryptopunks contract and was modified to include unique editions and royalty payments. 

(_Trivia: if you check line 365 in the code, you will notice it still has the word “punk” in the comment for the transfer function._)

Each ERC-20 token in the collection is uniquely identified by a `PrintIndex` stored in the contract. This makes the tokens effectively non-fungible, as the transfer function requires a specific `PrintIndex` as well as a `drawingId` to be specified when transferring a token.

# Token Metadata
Metadata values were assigned right after contract creation by a series of transactions of type `newCollectible` - one for each of the 108 drawings in the collection. The information stored in the metadata is:

### drawing id 
Unique id for each artwork image. Artworks in the C&W collection were originally created using the DADA online drawing tools and saved as a 2048 x 1536 pixel PGN file (with the exception of four older images that are only 640 x 480 pixels). 

### checksum 
SHA-256 hash of the image file. Can be used to verify that a token refers to a specific drawing. The images matching the checksum are available in this GitHub directory: 
https://github.com/powerdada/dada_sc/cw_drawings/

(_* please see notes for an exception & an enigma_)

### total supply 
Number of editions for each drawing (10, 70, 100, 150 or 200).

### initial price
Drawings were assigned an initial price in 2017, depending on their rarity. At the time, the extremely rare drawings had a price in ETH equivalent to 250 USD. Three of the common drawings by artist “Dada” could be claimed for free.

### initial print index 
Lowest print index for a specific drawing. Together with total supply, this defines a range of possible print indexes for each drawing. Print index is unique for each token and was not assigned sequentially, but randomly within each drawing specified range.

### collection name 
All tokens are part of only one collection: Creeps & Weirdos.

### author id 
Identifies the artist who created the drawing. 

Author id | Artist Name | Date of first drawing on DADA
------------ | ------------- | ------------- 
7 | Bea (Beatriz Helena Ramos) | 2014-04-11 17:36:11
18 | Dada | 2015-09-28 19:14:33
174 | Brian Mosch | 2014-09-08 16:25:45
700 | Raúl Ávila | 2014-09-10 18:22:53
1213 | Lorena Pinasco | 2014-09-10 15:20:50
1991 | Moxarra | 2014-10-28 15:52:46
5041 | Talita Sotomayor | 2015-09-05 22:19:19
5158 | Boris Toledo Doorm | 2015-09-06 00:37:33
10556 | J'erre (Javier Errecarte) | 2015-09-13 13:40:31
23099 | Carlos Márquez | 2015-10-26 17:04:46
27452 | Thana (Roxana Arrazola) | 2015-10-01 16:17:32
29482 | Cromomaniaco | 2015-09-27 13:49:00
30147 | María García | 2015-09-28 09:06:09
30693 | Serste (Serena Stelitano) | 2016-04-13 12:56:11
31625 | Gaston Spur | 2015-10-01 11:54:29
46607 | Otro Captore (Susana Riveros) | 2015-10-30 09:57:23
55499 | Jonathan D-Arte (Jonathan Duarte) | 2015-11-25 23:54:18
58626 | Erick Sánchez | 2015-12-02 06:16:44
60806 | Boris Z. Simunich | 2015-12-06 21:29:08
78012 | Hernan Cacciatore | 2016-01-12 17:32:30
84397 | Norma Xelda Jara | 2016-01-25 12:46:28
85354 | Mauricio Rodriguez | 2016-01-27 01:00:09
86797 | Massel | 2016-01-29 22:45:28
87601 | Franklin Piragauta | 2016-02-01 10:37:49
94228 | Sebastián García | 2016-02-09 01:53:13
114441 | Salvador Núñez | 2016-03-09 16:36:11
114687 | Betunski | 2016-03-10 03:42:47
132811 | Thaumatropio | 2016-04-10 07:32:48
135942 | vVs (Vanesa Stati) | 2016-04-15 23:11:10
151905 | Odrisea (Adriana López) | 2016-05-18 02:15:12

### scarcity 
Description of scarcity level (Common, Uncommon, Rare, Very Rare, Extremely Rare).

Scarcity was not based on a qualitative assessment about the art or the artist, but on the importance of the conversation the drawing belongs to. If it only had a reply or two it would be a Common, if it belonged to a long and cohesive visual conversation it would be an Extremely Rare.

----

### How to retrieve metadata values for a token
 
In Etherscan, use the “Read Contract” tab to query the function `drawingIdToCollectibles`. 

https://etherscan.io/address/0x068696a3cf3c4676b65f1c9975dd094260109d02#readContract

Enter a drawing id to see the metadata values associated with it.

obs: the values `nextPrintIndexToAssign` and `allPrintsAssigned` refer to unused contract variables. `initialPrice` shows the historical initial price for the drawing. All editions of the drawings have now been purchased and their prices are set freely by token owners on the secondary market.

### How to verify the checksum hash for a drawing
 
You can use a command line similar to `openssl sha -sha256 filename.png` or one of several online and standalone tools that calculate a SHA256 hash.

### Metadata table

Metadata values for all 108 drawings in table format. The first 6 columns are for data stored in the contract and can be retrieved as explained above. Three additional columns include extra information: artist name, drawing creation date, URL for conversation the drawing is part of.

scarcity | totalSupply | authorUId | drawingId | checkSum | initialPrintIndex | artist name | creation date | conversation 
------------ | ------------- | -------------  | ------------- | ------------- | ------------- | ------------- | ------------- | -------------
extremely rare | 10 | 46607 | 54433 | 23f9527d2ac079c2638ee41fa7b1b49f9bb8644f19f2bbbd092b89b094cb8798 | 3370 | Otro | 2016-03-03 | https://dada.art/pa/55127
extremely rare | 10 | 46607 | 72381 | 4ca301cf98a18f2d2be3522d0ee568b770d2bc07ac3d0a52b0acde4b64581b30 | 17590 | Otro | 2016-05-09 | https://dada.art/pa/73063
extremely rare | 10 | 7 | 80378 | a763b3897984812d9ffd3df181babae629f6d9d52ee72c6486ee159268189dd4 | 11910 | Bea | 2016-08-20 | https://dada.art/pa/81040
extremely rare | 10 | 7 | 80415 | 2752cd0739a1992f8556191c2542b10885244829703675e2c36dfbf5515168c8 | 2960 | Bea | 2016-08-21 | https://dada.art/pa/81077
extremely rare | 10 | 7 | 87469 | 59b85bf7f34a77da8303d5fffaee3d2a09e23aa0a94acaea4743811f932a100d | 7990 | Bea | 2017-04-14 | https://dada.art/pa/88109
very rare | 70 | 10556 | 54976 | cfb88d36d1eb026f9d594c962090e14ac77e8c38f545ba3bedb18c555c9ba602 | 1350 | J'erre | 2016-03-05 | https://dada.art/pa/55669
very rare | 70 | 7 | 58654 | 4477b6a12e5ad581d1ac490bfe4d1e11576bc4593ad920fc8f4be35cdd6b10b0 | 10420 | Bea | 2016-03-17 | https://dada.art/pa/59346
very rare | 70 | 7 | 72491 | 93322a9402c4a6b4486a979a435df4f828983489bc600e87ff0d3d00e577e513 | 1840 | Bea | 2016-05-09 | https://dada.art/pa/73173
very rare | 70 | 23099 | 76093 | fb65442b755c4ecbf51fbef6b52ad6ec8de789de96becd44abfe8a8c55ced89c | 1620 | Carlos Márquez | 2016-06-06 | https://dada.art/pa/76773
very rare | 70 | 60806 | 76132 | c0034fdb38c871e3f5bd064968f6ff11a5a20d16ad87e915d1372fc4e56c2f4c | 5330 | Boris Z Simunich | 2016-06-07 | https://dada.art/pa/76812
very rare | 70 | 114441 | 80530 | c49bd85e2448587bc8991f2f172ec9d1dd46f51a52f50d7cc235275a189db0d0 | 10350 | Salvador Núñez | 2016-08-24 | https://dada.art/pa/81192
very rare | 70 | 46607 | 82063 | 999aa802a6bf2106d9b7eb0394a3705a0edf9e92f13644ae74b53a77fd4ba567 | 6070 | Otro | 2016-10-04 | https://dada.art/pa/82725
very rare | 70 | 7 | 82599 | 1735dd15456e1a72baa4cc831bcfe06f2a19e6a658e75518b314acd591582da7 | 5600 | Bea | 2016-10-16 | https://dada.art/pa/83259
very rare | 70 | 5158 | 82760 | 81d9663c0dd3970b12a894bc0770a25ae7402f74695cd3f9143ea839b0998cdb | 10790 | Boris Toledo Doorm | 2016-10-22 | https://dada.art/pa/83420
very rare | 70 | 29482 | 87009 | 37949d851922f5429a33521f0e12d751bee2173c1ff446147ab2c195f173e1fd | 15770 | Cromo | 2017-03-29 | https://dada.art/pa/87649
rare | 100 | 1991 | 1182 | 4928ad32e5ffaf5c0c6ccd5614db4f9a7211625a5bda05a31d39c119cd4418da | 11920 | Moxarra | 2014-10-28 | https://dada.art/pa/1808
rare | 100 | 29482 | 15695 | cb925ecddabfab1bc5b49d9ddecd1e1ac16efb8b08371efec67e93a266b5af7e | 10490 | Cromo | 2015-10-05 | https://dada.art/pa/16424
rare | 100 | 1991 | 21538 | 6a01b5ebdc497a4afaf9864c3c593b421c92c29eeb5b1daba0bb845e39e8e227 | 4180 | Moxarra | 2015-10-30 | https://dada.art/pa/22260
rare | 100 | 60806 | 31456 | 8ca7e0ec6eb25922c91124e6a4c7f9f33ded893be2039950d93ec0359cef35ee | 4880 | Boris Z Simunich | 2015-12-10 | https://dada.art/pa/32164
rare | 100 | 29482 | 34393 | 415fed056ac199542500093273e0ac118fd9995106d197036c37d5ceefa264cf | 4480 | Cromomaniaco | 2015-12-22 | https://dada.art/pa/35098
rare | 100 | 23099 | 48426 | cd4dca8224d015d04d0566e587beefde0e3d9dc386a644b680afbbbded5eb849 | 16340 | Carlos Márquez | 2016-02-14 | https://dada.art/pa/49121
rare | 100 | 29482 | 76969 | 429982e60bdc533179ca4b4994caaf0dacd1a8afb2816ee732268cd96dfdefb3 | 4080 | Cromomaniaco | 2016-06-16 | https://dada.art/pa/77648
rare | 100 | 46607 | 79527 | 7547913ed92936e897b3c16bca5a63612790863d4dd23ed98c2df2e311fbe5f6 | 1910 | Otro | 2016-07-30 | https://dada.art/pa/80201
rare | 100 | 114441 | 79559 | 8e6c10b75d9aa301a6b10f86c7211adc464b7d0bb4d12ae49763f9ba60ce0383 | 9150 | Salvador Núñez | 2016-07-31 | https://dada.art/pa/80233
rare | 100 | 5158 | 79944 | 55c62712a46126ec553c0bc3881fbb42741408316855aa53aab22b5be2d1d279 | 14470 | Boris Toledo Doorm | 2016-08-10 | https://dada.art/pa/80606
rare | 100 | 46607 | 80495 | 839ffb26fa2c1de075d02d24f9093827d668a1a3cca9d37f14b4541bbb19c73a | 5670 | Otro | 2016-08-23 | https://dada.art/pa/81157
rare | 100 | 1213 | 82416 | c4d7c4de109e88e0cefafbc995a9bc1a341176f4ee9cf479a1458ad33f25889b | 15840 | Pinasco Lorena | 2016-10-12 | https://dada.art/pa/83076
rare | 100 | 29482 | 82521 | dc45dc5ff991931b1df31d3a1c0411a8b04c0c56828b22f6caa8c3b1e6192725 | 9450 | Cromomaniaco | 2016-10-14 | https://dada.art/pa/83181
rare | 100 | 55499 | 82596 | 88b93eee277776361b18a78d9fa71a76ca5a512f230b5191938427a28142667e | 5970 | Jonathan Duarte | 2016-10-16 | https://dada.art/pa/83256
rare | 100 | 30693 | 89039 | 8497964f6123e6b1c2ca9459c4d846afe62b3903e5a2b8f696dbf1f767ba12f0 | 9900 | Serste | 2017-07-06 | https://dada.art/pa/89679
uncommon | 150 | 174 | 1468 | f551b940d60be2aee2880f95d6d0bf49422f16733dd74a01e1636e410c9a5696 | 4730 | Brian  Mosch | 2014-11-04 | https://dada.art/pa/2105
uncommon | 150 | 700 | 1474 | d5b4a8bd0ba37e89adfe32a62a75c7292d03162bf331128e54dcf97da14ad938 | 2210 | raulavila | 2014-11-04 | https://dada.art/pa/2111
uncommon | 150 | 700 | 2374 | 711814ea9a4e7d62f272fe69f2e04078d5e29b7465fd6c164a0d75f17a6685e3 | 7690 | raulavila | 2015-01-20 | https://dada.art/pa/3025
uncommon | 150 | 174 | 9898 | 5cfcb06aaa68a9e73f7afeaa93fcc159561703e2d35d8a5257305f293f079e67 | 17240 | Brian  Mosch | 2015-09-20 | https://dada.art/pa/10593
uncommon | 150 | 23099 | 20906 | e79383909b345c72c2bb6fbe599e9d8cbf8eadc603bc040781b25bf9ad5ce15e | 13520 | Carlos Márquez | 2015-10-28 | https://dada.art/pa/21629
uncommon | 150 | 29482 | 22441 | f260a7b33b170eea98dff1fdc6be5c729a9cc0bce61a3662a2a05d839c712239 | 3380 | Cromomaniaco | 2015-11-02 | https://dada.art/pa/23163
uncommon | 150 | 23099 | 28673 | b711772bb36164cddc4fc64f7e358d2fb2c6c9b5bbdd2f94bb786ba090be46b2 | 4580 | Carlos Márquez | 2015-11-29 | https://dada.art/pa/29383
uncommon | 150 | 29482 | 31476 | d91ed015b42998dbece4cd1334e840e86a9f790bb30df95dff390604de1c86a2 | 11560 | Cromomaniaco | 2015-12-10 | https://dada.art/pa/32184
uncommon | 150 | 23099 | 32163 | d7718f81659daeabf53103f371c71a9713aa78935a60e74205e5989adeac83f8 | 12620 | Carlos Márquez | 2015-12-14 | https://dada.art/pa/32871
uncommon | 150 | 7 | 34861 | de3577cd6551594d7e30de1ca6ae7be04d5c054add424d417c1b7960067a9e82 | 6790 | Bea | 2015-12-24 | https://dada.art/pa/35566
uncommon | 150 | 46607 | 53293 | 3c90192b6ba5437f1e8a93681dc7dddc83fa865a31003967c8bccb5ca5c13e02 | 6340 | Otro | 2016-02-29 | https://dada.art/pa/53987
uncommon | 150 | 27452 | 53508 | c2d6d6bd2650eac6ef399c3f5c0a87dbe80ebc6e2595f7db99a73b4937fdf2ec | 7340 | Thana | 2016-02-29 | https://dada.art/pa/54202
uncommon | 150 | 87601 | 53558 | 81e26fb7b6dc1399f0531dd469e93520544894f8cfd7655e70323ee4823cbee9 | 3930 | Franklin Piragauta | 2016-02-29 | https://dada.art/pa/54252
uncommon | 150 | 29482 | 54744 | 1ad5afcdb3a3377f26722874d9ef8f0b8a04c91ae5efaaedd5a4975d263a8b37 | 6490 | Cromomaniaco | 2016-03-05 | https://dada.art/pa/55437
uncommon | 150 | 46607 | 57680 | f1b684efe17db413817372e955d5e832f7ae6331584f127b1b09a9a28d3a00aa | 9550 | Otro | 2016-03-14 | https://dada.art/pa/58373
uncommon | 150 | 7 | 59222 | 7d14e14b30d4169130835c2ef3c132b9126564064a362b6f7628bfb67660d612 | 13370 | Bea | 2016-03-19 | https://dada.art/pa/59914
uncommon | 150 | 86797 | 61322 | 841f3786889727927dbda649ea220a3c1bca878a00284255d00762d1c5c0ad9f | 10000 | Massel | 2016-03-25 | https://dada.art/pa/62013
uncommon | 150 | 30693 | 67505 | 5a6b2f0f4e4ef79bf60bd0cf3b01fad8261d6ca86c725886a0c77d7ba5ac5390 | 6640 | Serste | 2016-04-16 | https://dada.art/pa/68189
uncommon | 150 | 46607 | 73495 | dd432bc1e0eaaf9906ee80f0d3600291d5e068fd0b38d83aea6b3a9d94a1c54d | 10860 | Otro | 2016-05-16 | https://dada.art/pa/74177
uncommon | 150 | 700 | 74518 | b719bc7a2705f426f2b95b963c9aaaa0763da4f1707c00f80c4f11a5a29c1cd6 | 1000 | raulavila | 2016-05-25 | https://dada.art/pa/75199
uncommon | 150 | 700 | 81087 | 20386ba41a34ea925e993aacbe55d96fbfa272c173f072afd2c5e608b337c9da | 11210 | raulavila | 2016-09-06 | https://dada.art/pa/81749
uncommon | 150 | 700 | 82882 | 10aeb49beb5fdb12da9bdc7cbf8e304836900a88218f781f7d128b2bda7dad95 | 4980 | raulavila | 2016-10-26 | https://dada.art/pa/83542
uncommon | 150 | 29482 | 83227 | a06f1c46b15ddc6d2ff9949f3bde6dc8e8503f9dc53596c1f4e9de58b6bea79e | 7840 | Cromo | 2016-11-07 | https://dada.art/pa/83887
uncommon | 150 | 1991 | 83489 | 8ce5f70eff449bd8aaa7a1fc6dc345350ec2237982bfc30548e14214cc95977d | 8200 | Moxarra | 2016-11-17 | https://dada.art/pa/84149
uncommon | 150 | 30693 | 84187 | abaf6f468aa2807a4aae3a0b93d21b49f73109235e4282cda974cadd3b123a8e | 1690 | Serste | 2016-12-11 | https://dada.art/pa/84847
common | 200 | 1991 | 4763 | 2c4887e07dfc42b9add14db8fa761cdab2603176628fbdcf77c530862a32f057 | 2010 | Mox | 2015-09-09 | https://dada.art/pa/5433
common | 200 | 27452 | 15280 | f441012ff12f863aa8ca24ac6ecce806cde60719630e770c0b54ab750e805257 | 14770 | Thana | 2015-10-04 | https://dada.art/pa/16009
common | 200 | 10556 | 17078 | fbf5fce64f8b27ea902a4793d1e00b5888846d5c747da5efa36543a1dd43fe9b | 10590 | J'erre | 2015-10-11 | https://dada.art/pa/17806
common | 200 | 23099 | 21715 | a4213d4575090a344673f5b1d3e33065bdd2797023d3741a26ae50d37b10c901 | 8750 | Carlos Márquez | 2015-10-31 | https://dada.art/pa/22437
common | 200 | 174 | 22132 | d7cfd740918776e81035b87d3a07e2732926196a02fa03e4ec346277d71bfce2 | 6940 | Brian  Mosch | 2015-11-01 | https://dada.art/pa/22854
common | 200 | 31625 | 28657 | 9a3c50316521e6ec6eee72129d12d42b8d8000ce4f37a84f602662783848d1a3 | 7140 | Gaston Spur | 2015-11-29 | https://dada.art/pa/29367
common | 200 | 5041 | 41923 | b2768a35b3b9c66c1d6963809698035bbf8e486af6dc10b17f9e01a71f3e8bc8 | 11710 | Talita  | 2016-01-26 | https://dada.art/pa/42620
common | 200 | 85354 | 43154 | 51e6ad13a74e26ad05b3b537f7d2aa526b9bd79e90902763c77e805d92658fdc | 2560 | Mauricio | 2016-01-30 | https://dada.art/pa/43850
common | 200 | 29482 | 46744 | 244a649178902c80a3f57f6166fbf22360e2200f9033c5a6b8195fa4f07d0e07 | 10150 | Cromomaniaco | 2016-02-10 | https://dada.art/pa/47440
common | 200 | 1991 | 51616 | 4416389f407ba7fe37d05d3d5ccc4c6a1b6e69edb33b8ef0639e7d69d03583d4 | 16640 | Moxarra | 2016-02-24 | https://dada.art/pa/52310
common | 200 | 18 | 53974 | 0eec399461621a8eaac82a4d590cc8f390c384e47a9a9e7561385168c689d97d | 3730 | Dada | 2016-03-02 | https://dada.art/pa/54668
common | 200 | 87601 | 53977 | c09d3b774d42bd4580ccf7e59f446af260f6d6a290337996ae81aaa2c932c0fe | 8000 | Franklin Piragauta | 2016-03-02 | https://dada.art/pa/54671
common | 200 | 10556 | 56281 | 329b21ee56f795a4118c71372d9c5e66cdd6b7861c9f02d66e701acc47daa04c | 8350 | J'erre | 2016-03-10 | https://dada.art/pa/56974
common | 200 | 46607 | 58636 | 757bd01ed4e0accf9ac37b7f5fb45ea69fb0a2b05f200578f31eacc40778989b | 15940 | Otro | 2016-03-17 | https://dada.art/pa/59328
common | 200 | 132811 | 65943 | 8d7f33c66e3da66d7f6158d561464143ebd3bb232500ec749a7b5dcb28f907fa | 15370 | thaumatropio | 2016-04-10 | https://dada.art/pa/66633
common | 200 | 114687 | 66104 | bc060277b8bb857d065534d23dc03f1077f04d9e710711d99f8ca73ac936a23c | 17040 | Betunski | 2016-04-10 | https://dada.art/pa/66794
common | 200 | 46607 | 67968 | 08a14618a3de3941acb926c44d9efdd5eec54adeafcc4d85a21f7ab19807f454 | 11360 | Otro | 2016-04-17 | https://dada.art/pa/68651
common | 200 | 84397 | 67976 | 218d753ba2f8f563f0da22eec747ba6c809831fe9f3f807c68a4d657625b4a38 | 2970 | Norma Xelda Jara | 2016-04-17 | https://dada.art/pa/68659
common | 200 | 132811 | 68986 | 0df0654a3132c355faf94872bef72362fd48595f7fd65241652bef30ac24c421 | 1420 | thaumatropio | 2016-04-22 | https://dada.art/pa/69668
common | 200 | 86797 | 73378 | 805a3bf1d2ae5670dd1326297a2c88a0164556df93c9288e2d37df6f289f75eb | 2360 | Massel | 2016-05-15 | https://dada.art/pa/74060
common | 200 | 132811 | 73587 | c44724a1dc5b7a8db57cf98ae394a2456d2b4a04247fe4354fd8dee7312d4fef | 14570 | thaumatropio | 2016-05-17 | https://dada.art/pa/74269
common | 200 | 10556 | 74145 | de3f9c10c892b46f05703f2b15c27dfb4c535f8b2927367396316ba725c3cdc2 | 16440 | J'erre | 2016-05-21 | https://dada.art/pa/74827
common | 200 | 94228 | 74217 | bc45d6fab1e907156ff20b7cbc89197ab554cca245224ff4a1325ce4af1e3569 | 15570 | Sebastián García | 2016-05-22 | https://dada.art/pa/74898
common | 200 | 60806 | 75852 | 6d2f1d7d7d00d8555acb7b6c25c359ffba5d6cbc20c62fa30c91390a512fdcd8 | 9700 | Boris Z Simunich | 2016-06-05 | https://dada.art/pa/76532
common | 200 | 78012 | 77590 | a718d2751ed58ddd56bfc05da504002a92bd690a618ab16068f3e9c4057a32e8 | 2760 | Hernan | 2016-06-25 | https://dada.art/pa/78269
common | 200 | 94228 | 79117 | 64fb3dd24bb3113459b8b6f59dfd06cc0f621e5e073557ab5cf4a554d1ba0a59 | 12020 | Sebastián García | 2016-07-23 | https://dada.art/pa/79790
common | 200 | 5158 | 79148 | a352d5d0ecd31adaf5edecde82e3bc4765544d2ceefd36d15c5f3b84471b9807 | 3530 | Boris Toledo Doorm | 2016-07-24 | https://dada.art/pa/79822
common | 200 | 5158 | 79673 | 091fe181f5cc1327bc806ac0f80c0e19b12b5bcf69e081845f4177ed8661ad3c | 15170 | Boris Toledo Doorm | 2016-08-02 | https://dada.art/pa/80347
common | 200 | 60806 | 81696 | aed7ca04b4fc78afb93de4b6325afd096e79297020721d9f66ea363772178fab | 14970 | Boris Z Simunich | 2016-09-23 | https://dada.art/pa/82358
common | 200 | 1991 | 81908 | 712d14ee5d8aa12ecca1685c150d886a292816cb2f1b56f26b95c3ae668cfadd | 6140 | Moxarra | 2016-09-28 | https://dada.art/pa/82570
common | 200 | 1213 | 82654 | 8ea079a26ddc4809bcd3dd14d7049ce09c8c170f92a46e4bc1d4fc5f763de3b6 | 5130 | Pinasco Lorena | 2016-10-18 | https://dada.art/pa/83314
common | 200 | 7 | 83039 | 78514b4cee27ef6adada9458ec67d785bbe59636b348dd237620934c4d001a07 | 4280 | Bea | 2016-11-01 | https://dada.art/pa/83699
common | 200 | 5158 | 83616 | 1ce7838f3dd4316d7770e5d2801b9333f04832db6b7ae013c17fc11098ae4300 | 1150 | Boris Toledo Doorm | 2016-11-20 | https://dada.art/pa/84276
common | 200 | 10556 | 83739 | 81c6e6bb6d37cf9acf44ed02f6494dcdf94076f55b6626282525d56d981be583 | 8950 | J'erre | 2016-11-25 | https://dada.art/pa/84399
common | 200 | 7 | 83781 | 08339ebdbd7dd5df4bdade49b511ace934324a492f7d16f694134b7085638dbc | 13870 | Bea | 2016-11-28 | https://dada.art/pa/84441
common | 200 | 7 | 83798 | 75dd990d75297a8802fcb8ab8af049a862a181ab891076f60ae035c425607789 | 16140 | Bea | 2016-11-29 | https://dada.art/pa/84458
common | 200 | 18 | 84381 | aa5f09a9364f8dbfd7990f281dce64247f2f48e40a7c463e915c1a33223fbc9f | 5770 | Dada | 2016-12-20 | https://dada.art/pa/85041
common | 200 | 86797 | 85364 | ace1daf7ea83856a97117808bf840d4e1b71e348cd5637efdecae62a4aa9a3c6 | 7490 | Massel | 2017-01-30 | https://dada.art/pa/86024
common | 200 | 84397 | 85841 | 20c2f5e3031928d9c98f36920be3bf65e3939482a2c5ff474c02e9873cfbfb54 | 13670 | Norma Xelda Jara | 2017-02-13 | https://dada.art/pa/86501
common | 200 | 30147 | 86105 | 123eefd2a3bf40a3a61339553c0147a1c9da8312deb7469075fa289303bba8ce | 17390 | Maria Garcia | 2017-02-22 | https://dada.art/pa/86765
common | 200 | 18 | 86667 | 1e187de356ba6721d54afa8bf42cc8ec660b5bf6e04088448ee431529db2b9c2 | 3170 | Dada | 2017-03-19 | https://dada.art/pa/87307
common | 200 | 58626 | 87018 | cb3f34e9436c56d7f6198072a83c0250c69467cd53aab5f52eb5dad541d041cc | 12770 | Erick Sánchez | 2017-03-29 | https://dada.art/pa/87658
common | 200 | 30693 | 87472 | 5ef594100b18b46b37196eba6cb11ba32a2b8781a6cb65ae7822888db02fb441 | 12220 | Serste | 2017-04-15 | https://dada.art/pa/88112
common | 200 | 1991 | 87586 | 7507032aca000759ee2646c6f9cd50340c3a12603f6bc55383162eba18b7bfc7 | 8550 | Moxarra | 2017-04-21 | https://dada.art/pa/88226
common | 200 | 700 | 87590 | 45bb94e30f2aff79815b7004fd65670a2ea0ea994cdff3e5a2f94af92de38629 | 9250 | raulavila | 2017-04-21 | https://dada.art/pa/88230
common | 200 | 135942 | 87989 | 438db5c9f5079df5fc3b1a669ff85073a33e6be2c945bc4dc99bc22ba5e443cd | 12970 | vVs (Vanesa Stati) | 2017-05-16 | https://dada.art/pa/88629
common | 200 | 30693 | 89198 | 3e9460c88b48be8367b1a4075889cbf2f81505e8a5dd9ed4bd8f124cfff535e5 | 14270 | Serste | 2017-07-14 | https://dada.art/pa/89838
common | 200 | 5158 | 89417 | 043e7bb35a454937b9712c6d3cae95ed6aba94924983c88461534134f2dbe9df | 16840 | Boris Toledo Doorm | 2017-07-30 | https://dada.art/pa/90057
common | 200 | 30147 | 89543 | 8beed369c06d176a6cb1631a09979e798efcd1189a3c51ab9b4c567470e1ed11 | 14070 | Maria Garcia | 2017-08-07 | https://dada.art/pa/90183
common | 200 | 1991 | 89553 | c9f1ea3dd5dac881695e24e2dd7fb2bb02e97233c414e0403f48b87d81d91aa3 | 13170 | Moxarra | 2017-08-08 | https://dada.art/pa/90193
common | 200 | 135942 | 89934 | b921a64d964c46c7df45244fdd475e65862a406d246b1c9563a494d8a55e21dd | 5400 | vVs (Vanesa Stati) | 2017-09-22 | https://dada.art/pa/90574
common | 200 | 5158 | 89951 | c8142a54a8df8c817888f89f9d225389f2db515e14d83deb3044ac9c475e4ca9 | 12420 | Boris Toledo Doorm | 2017-09-26 | https://dada.art/pa/90591
common | 200 | 151905 | 89955 | f591adcd298d1a24f2cd2b138d4309fc05e682fe44afdba130b3fcecee60c69b | 11010 | Odrisea | 2017-09-27 | https://dada.art/pa/90595

# Notes

### Enigma 
Drawing Id 86105 corresponds to a drawing by María García. We don't know what happened, but the exact file used to generate the hash (checksum) present in the contract can't be found. It was likely overwritten in the database by a version with the same exact pixels but containing a different timestamp. 

DADA's online drawing tool saves each drawing as PNGs in several resolutions and writes a timestamp in the file name as well as in the last bits of the file itself. We know that the timestamp in the file name and the one inside the file are several months apart. The date of the 2017 C&W contract deployment lies in between this time interval. 

The artist María García named the drawing “Estefi, Enigma”, and it seems its digital file is now - very appropriately - an enigma in itself.

Maybe Estefi wished to play a Halloween joke, evading blockchain provenance by causing a technical glitch and updating her timestamp at the end of the file, while keeping all her pixels intact ;)

**We advise all buyers of this drawing to be aware of this fact.**

We don’t know if the original time stamp could ever be reconstituted, but if it could, then we could theoretically have again a file matching the hash in the contract.
