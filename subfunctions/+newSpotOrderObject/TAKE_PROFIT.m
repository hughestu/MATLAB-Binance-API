classdef TAKE_PROFIT < newSpotOrderObject.Order & sortProps
    %  spot.TAKE_PROFIT - object for spot.newOrderO. A stop loss order can 
    %  be or buy side.
    
    properties (Constant = true, Hidden = true)
        orderType (1,:) char = 'TAKE_PROFIT'
    end
    
    properties
        stopPrice (1,1) double = 0
    end
    
    methods
        function obj = TAKE_PROFIT
             obj@sortProps([2:4 1 5:8])
        end
    end
end

