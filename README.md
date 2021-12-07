[![View MATLAB-Binance-API on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api)

# MATLAB Binance API
Suite of functions for accessing the [Binance API](https://binance-docs.github.io/apidocs/spot/en/#introduction) via MATLAB (R2019b or later). This package supports spot and margin trading and all public endpoints.  
##### v0.1.6

### Features
* Access all historical market data (from 1 week candles to individual trades)
* Load market data for large time ranges (pub.repAggTrades, pub.repKlines)
* Simple authentication setup
* Spot trading
* Cross margin trading (transfers, loans, repayments, orders)
* Isolated margin trading (transfers, loans, repayments, orders)
* 'max' quantity option for transfers/loans/repayments
* Server error messages. Filter errors give the corresponding filter requirements.
* Examples and comprehensive help documentation in all functions.

### To get started 
1.	Download and place this folder in your MATLAB directory, then add it (and all its subfolders) to the user path. 

2.  Make your public and private keys accessible via `[pubKey,secKey] = getkeys(username)` as follows: (i) copy your public and private keys into getkeys_Template.m (see: MATLAB-Binance-API/subfunctions/getkeys_Template.m); (ii) rename getkeys_Template.m to getkeys.m.

3.  Verify that the authentication works correctly. You can do this by calling `[~,~,response] = spot.accountInfo` and then checking that the response contains an HTTP status code of 200.

4.	At this point, I recommend generating a list of functions contained in the toolboxes by calling `help spot`, `help pub`, `help cmargin` and/or `help imargin`. The lists provide a one-line description of what each function does and links to further information for each function. I suggest starting with pub.* and spot.* before moving onto margin trading. 

5.	For different URL's, such as api.binance.us, you can modify subfunctions/getBaseURL.m as required. Note, I haven't been able to test api.binance.us but as far as I can tell, the endpoints are cross-compatible (feedback from anyone using .us would be appreciated).

Functions are scoped to pub.\* (for the public market data endpoints), spot.* (for the spot account endpoints), cmargin.\* (for cross margin trading) and imargin.\* (for isolated margin trading). Each functions' help documentation (such as `help spot.newOrder`) provide further info and, in all cases, at least one example showing how to use that function.   

### List of functions
#### Public (pub.\*) - No API keys required
aggTrades - returns public aggregated trade data for a specific symbol.   
bookDepth - returns up to 5000 bid/ask prices and quantities for a symbol.   
bookTicker - returns the best bid/ask price & qty for a symbol or symbols.   
exchangeInfo - returns info about each symbol (permissions, filters, etc.).   
getServerTime - returns the current Binance server timestamp.   
historicalTrades - returns market trade history for a specific symbol.   
klines - returns candlestick data for a specific symbol and interval.   
price - returns the latest price for a symbol or symbols.   
recentTrades - returns a list of recent trades for a specific symbol.   
repAggTrades - repeats calls to pub.aggTrades for larger datasets.   
repKlines - repeats calls to pub.klines for larger datasets.   

#### Spot (spot.\*)
accountInfo - returns spot account portfolio for default user.   
accountTradeList - returns your trades for a specific account and symbol.   
allOrders - returns (open/filled) orders for a specific account and symbol.   
cancelAllOrders - cancels all active orders on a symbol including OCO's.   
cancelOrder - cancels an active order given a symbol and order id.   
newOrder - creates an object for making orders of a given orderType.   
openOrders - returns all open orders on a symbol.   
queryOrder - querys an order's status.   

#### Cross and Isolated Margin (cmargin.\*, imargin.\*)
accountInfo - returns the account portfolio.   
allOrders - returns all orders (open and closed).   
callHistory - returns history of forced liquidations (margin calls).   
cancelAllOrders - cancels all orders.   
cancelOrder - cancels an order given the symbol and order id.   
interestHistory - returns interest history on loans.   
loan - requests a loan for a specific asset and quantity.   
loanRecord - returns the loan record.   
maxBorrowable - returns borrow limits.   
maxTransferableOut - returns current withdrawal limits.   
newOrder - returns an object for making orders.   
openOrders - returns all open orders.   
orderHistory - returns a previous order given the asset and order id.   
repay - repays a borrowed asset.   
repayRecord - returns a record of loan repayments.   
symbolInfo - returns info about each symbol.   
transfer - requests a transfer between spot and margin accounts.   
transferHistory - returns a list of transfers in and out of margin. 

### Releases
v0.0.0 - First release with main components of spot.\* and pub.\*.  
v0.1.0 - Support for cross and isolated margin trading via cmargin.\* and imargin.\* (29 endpoints). 

### Feedback
If you've benefited from the code, please consider leaving a review/rating on my [FEX Submission](https://uk.mathworks.com/matlabcentral/fileexchange/95558-matlab-binance-api).
    
