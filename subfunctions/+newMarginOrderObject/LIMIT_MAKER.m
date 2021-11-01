classdef LIMIT_MAKER < newMarginOrderObject.Order & sortProps
    % LIMIT_MAKER is an object for creating limit-maker orders. Limit-maker 
    % orders are rejected if they match for trading as a taker. Hence, this
    % order type ensures a maker order.
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
    % SEE ALSO: 
    % <a href =  "https://binance-docs.github.io/apidocs/spot/en/#new-order-trade" >docs</a>, <a href = "https://www.binance.com/en/support/faq/5d3fa5e5709f47e0b5f186b350da1655" >faq</a>
    % 
 
    
    properties (Constant = true, Hidden = true)
        orderType (1,:) char = 'LIMIT_MAKER'
    end
    
    properties
        price       (1,1) double = 0
        icebergQty  (1,1) double = 0
    end
    
    methods
        function obj = LIMIT_MAKER(isIsolated)
            arguments
                isIsolated = false
            end
            obj@sortProps([3:5 1 2 6:8])
            obj.isIsolated = isIsolated;
        end
    end
end

