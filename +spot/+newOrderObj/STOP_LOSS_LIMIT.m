classdef STOP_LOSS_LIMIT < spot.newOrderObj.Order & sortProps
    % STOP_LOSS_LIMIT is an object for making stop-loss-limit orders. 
    % A stop loss limit order is the same as a stop loss but instead of 
    % triggering a market order it triggers a limit order. 
    % The stopPrice is the price that triggers the limit order, which has
    % it's own price - the limit price (i.e. the price you are offering to 
    % buy to at). Once your stop price has been reached, your limit order 
    % will be immediately placed on the order book.
    %
    % Mandatory parameters:
    %   symbol
    %   side
    %   quantity
    %   price (a.k.a. the limit price)
    %   stopPrice
    %
    % Optional parameters:
    %   timeInForce
    %   newClientOrderId
    %   isTest
    %   recvWindow
    %   accountName
    %
    % SEE ALSO: <a href = "https://binance-docs.github.io/apidocs/spot/en/#new-order-trade">docs</a>

    
    properties (Constant = true, Hidden = true)
        orderType = 'STOP_LOSS_LIMIT'
    end
    
    properties
        price       (1,1) double    = 0
        stopPrice   (1,1) double    = 0
        timeInForce (1,:) char      = 'GTC'
    end
    
    methods
        function obj = STOP_LOSS_LIMIT
            obj@sortProps([4:6 1:3 7:10])
        end
        
        function set.timeInForce(obj,timeInForce)
            timeInForce = upper(timeInForce);
            
            assert(contains(timeInForce,{'GTC','IOC','FOK'}),sprintf(...
                ['Invalid input for timeInForce. Valid timeInForce '...
                'options\nare as follows:\n'...
                '''GTC'' - Good Till Cancelled\n'...
                '''IOC'' - Immediate Or Cancelled\n'...
                '''FOK'' - Fill Or Kill']))
            
            obj.timeInForce = timeInForce;
        end
        
    end
end

