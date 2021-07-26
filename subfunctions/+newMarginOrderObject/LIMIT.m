classdef LIMIT < newMarginOrderObject.Order & sortProps
    % LIMIT is an object for creating limit orders. Limit orders allow you
    % to specify a specific limit price. When you place a limit order, the
    % trade will only be executed if the market price reaches your limit
    % price (or better). You may use limit orders to buy at a lower price
    % or to sell at a higher price than the current market price.
    %
    % Mandatory parameters:
    %   symbol
    %   side
    %   quantity
    %   price
    %
    % Optional parameters:
    %   icebergQty
    %   timeInForce
    %   newClientOrderId
    %   isTest
    %   recvWindow
    %   username
    %
    % If valid values are assigned to the mandatory paramters then send the
    % order to binance via:
    % >> obj.send
    %
    % You can call obj.send multiple times to make more orders.
    %
    % SEE ALSO: <a href = "https://binance-docs.github.io/apidocs/spot/en/#new-order-trade">docs</a>, <a href = "https://academy.binance.com/en/articles/what-is-a-limit-order">academy</a>
    
    properties (Constant = true, Hidden = true)
        orderType   (1,:) char      = 'LIMIT'
    end
    
    properties
        price       (1,1) double    = 0
        icebergQty  (1,1) double    = 0
        timeInForce (1,:) char      = 'GTC'
    end
    
    methods (Hidden)
        function obj = LIMIT
            obj@sortProps([4:6 1:3 7:9])
        end
    end
    
    methods
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

