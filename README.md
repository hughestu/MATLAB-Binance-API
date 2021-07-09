[![View MATLAB-Binance-API on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api)

# MATLAB Binance API

Suite of functions for accessing the [Binance API](https://binance-docs.github.io/apidocs/spot/en/#introduction) via MATLAB (requires R2016b or later). This package supports all trading for spot accounts as well as most public end points. Future releases will support trading on margin accounts (v0.1.0) and using websockets (v0.2.0).

#### To get started 

1. Download and place this folder in your MATLAB directory then add it (and all its subfolders) to the user path. 

2. Make your keys accessible with a function called, getkeys.m on the userpath: You can copy your public and private keys into the getkeys_Template.m function located in at `.../subfunctions/getkeys_Template.m`, and then rename getkeys_Template.m function to getkeys.m.

3. From there I recommend generating a list of functions in the toolboxes which gives one line description of what each one does:

`help spot`

`help pub`

4. For different URL's such as `https://api.binance.us`, modify the `getBaseURL.m` function accordingly.


Each function in the spot and public (pub) toolboxes contain atleast one example that shows how to call it, for example see: 

`help spot.newOrder`


Some simple examples:

`pub.price('btcusdt')`

`spot.accountInfo`
