[![View MATLAB-Binance-API on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api)

# MATLAB Binance API
Suite of functions for accessing the [Binance API](https://binance-docs.github.io/apidocs/spot/en/#introduction) via MATLAB (R2016b or later). This package supports all endpoints for trading on spot accounts as well as most public endpoints. Future releases will support trading on margin accounts (v0.1.0) and using WebSockets (v0.2.0).

#### To get started 

1.	Download and place this folder in your MATLAB directory, then add it (and all its subfolders) to the user path. 

2.  Make your public and private keys accessible via `[pubKey,secKey] = getkeys(accountName)` as follows: (i) copy your public and private keys into getkeys_Template.m (see: MATLAB-Binance-API/subfunctions/getkeys_Template.m); (ii) rename getkeys_Template.m to getkeys.m.

3.  Verify that the authentication works correcty. You can do this by calling `[~,~,response] = spot.accountInfo` and then checking that the response contains an HTTP status code of 200.

4.	At this point, I recommend generating a list of functions contained in the toolboxes by calling `help spot` and `help pub`. This gives you a one-line description of what each function does and links to further information for each function.

5.	For different URL's, such as api.binance.us, you can modify subfunctions/getBaseURL.m as required. Note, I haven't been able to test api.binance.us but as far as I can tell, the endpoints are cross-compatible (feedback from anyone using .us would be appreciated).

All user functions are scoped to either pub.* (for the public endpoints) or spot.* (for the spot account endpoints). The functions' help documentation (e.g. `help spot.newOrder`) provide further info and, in all cases, at least one example showing how to use that function.

If you've benefited from the code, please consider leaving a review/rating on my [FEX Submission](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api).
