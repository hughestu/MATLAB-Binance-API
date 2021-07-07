# MATLAB Binance API
MATLAB Binance API

To get started 

1. Download and place this folder in your MATLAB directory then add it (and all its subfolders) to the user path. 

2. Copy your public and private keys into the getkeys_Template.m function located in the subfunctions folder. Then rename the getkeys_Template.m function to just getkeys.m.

3. From there I recommend generating a list of functions in the toolboxes which gives one line description of what each one does:

`help spot`

`help pub`

Each function in the spot and pub (public) toolboxes contain atleast one example that shows how to call it, for example see: 

`help spot.newOrder`


Some simple examples:

`pub.price('btcusdt')`

`spot.accountInfo`
