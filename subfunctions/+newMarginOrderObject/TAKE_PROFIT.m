classdef TAKE_PROFIT < newMarginOrderObject.Order & sortProps
    %  spot.TAKE_PROFIT - object for spot.newOrderO. A stop loss order can
    %  be or buy side.
    
    properties (Constant = true, Hidden = true)
        orderType (1,:) char = 'TAKE_PROFIT'
    end
    
    properties
        stopPrice (1,1) double = 0
    end
    
    methods
        function obj = TAKE_PROFIT(isIsolated)
            arguments
                isIsolated = false
            end
            obj@sortProps([2:4 1 5:7])
            obj.isIsolated = isIsolated;
        end
    end
end

