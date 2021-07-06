classdef TAKE_PROFIT_LIMIT < spot.newOrderObj.Order & sortProps 
    % TAKE_PROFIT_LIMIT is an object for making take-profit-limit orders.
    % Take profit limit's are limit orders that get triggered when the 
    % current price crosses the stopPrice. Buy limit orders are
    % triggered when the current price becomes less than or equal to the 
    % stopPrice, while sell limit orders are triggered with the current
    % price becomes greater than or equal to the stopPrice.
    
    properties (Constant = true, Hidden = true)
        orderType = 'TAKE_PROFIT_LIMIT'
    end
    
    properties
        price       (1,1) double    = 0
        stopPrice   (1,1) double    = 0
        timeInForce (1,:) char      = 'GTC'
    end
    
    methods
        function obj = TAKE_PROFIT_LIMIT
            % Constructor
            obj@sortProps([4:6 1:3 7:10]);
        end
    end
end

