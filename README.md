[![View MATLAB-Binance-API on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api)

# MATLAB Binance API

Suite of functions for accessing the [Binance API](https://binance-docs.github.io/apidocs/spot/en/#introduction) via MATLAB (R2016b or later). This package supports all endpoints for trading on spot accounts as well as most public endpoints. Future releases will support trading on margin accounts (v0.1.0) and using websockets (v0.2.0).

#### To get started 

1. Download and place this folder in your MATLAB directory then add it (and all its subfolders) to the user path. 

2. Make your keys accessible with a function called getkeys.m on the userpath: to do this, you can copy your public and private keys into getkeys_Template.m which is located at .../MATLAB-Binance-API/subfunctions/getkeys_Template.m, and then rename it as getkeys.m. You can call `spot.accountInfo` to confirm that the authentication is working.

3. From there I recommend generating a list of functions in the toolboxes by calling `help spot` and/or `help pub`. This gives you one line description of what each function does and links to further information for each function.

4. The package was created and tested using api.binance.com. For different URL's, such as api.binance.us, you can modify subfunctions/getBaseURL.m accordingly. Note, I haven't been able to test api.binance.us but as far as I can tell the endpoints are cross compatibile (feedback from anyone using .us would be appreciated).

Each function in the spot and public (pub) toolboxes contain atleast one example that shows how to call it, for example see: 

`help spot.newOrder`

All user functions are scoped to either pub.\* (for the public endpoints) or to spot.\* (for the spot account endpoints), e.g. the price functions in the public toolbox is called by `pub.price('btcusdt')`.
