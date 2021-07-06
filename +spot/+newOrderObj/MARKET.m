classdef MARKET < spot.newOrderObj.Order & sortProps
    % MARKET is an object for creating market orders. A market order is an 
    % order to quickly buy or sell at the best available market price. This
    % order type takes orders (e.g. limit order by another person) off of
    % the order book and is hence called a market taker.
    %
    % Mandatory parameters:
    %   symbol
    %   side
    %   quantity
    %   price
    %
    % Optional parameters:
    %   isQuoteOrderQty     (see <a href = "https://dev.binance.vision/t/beginners-guide-to-quoteorderqty-market-orders/404">dev.binance</a>)
    %   newClientOrderId
    %   isTest
    %   recvWindow
    %   accountName
    
    properties (Constant = true, Hidden = true)
        orderType       (1,:) char      = 'MARKET'
    end
    
    properties 
        isQuoteOrderQty	(1,1) logical   = false
    end
    
    methods 
        function obj = MARKET
            obj@sortProps([2:4 1 5:8])
        end
    end
end

