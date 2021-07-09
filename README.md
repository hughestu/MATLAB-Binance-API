[![View MATLAB-Binance-API on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api)

# MATLAB Binance API

Suite of functions for accessing the [Binance API](https://binance-docs.github.io/apidocs/spot/en/#introduction) via MATLAB (requires R2016b or later). This package supports all endpoints trading for on spot accounts as well as most public endpoints. Future releases will support trading on margin accounts (v0.1.0) and using websockets (v0.2.0).

#### To get started 

1. Download and place this folder in your MATLAB directory then add it (and all its subfolders) to the user path. 

2. Make your keys accessible with a function called getkeys.m on the userpath: To do this, you can copy your public and private keys into getkeys_Template.m which is located at .../MATLAB-Binance-API/subfunctions/getkeys_Template.m, and then rename it as getkeys.m.

3. From there I recommend generating a list of functions in the toolboxes which gives one line description of what each one does:

`help spot`

`help pub`

4. The package was created and tested using https://api.binance.com. For different URL's, such as https://api.binance.us, you can modify subfunction/getBaseURL.m accordingly.


Each function in the spot and public (pub) toolboxes contain atleast one example that shows how to call it, for example see: 

`help spot.newOrder`


Some simple examples:

`pub.price('btcusdt')`

`spot.accountInfo`
