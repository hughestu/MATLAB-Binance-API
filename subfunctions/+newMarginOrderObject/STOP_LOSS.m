classdef STOP_LOSS < newMarginOrderObject.Order & sortProps
    % obj = STOP_LOSS - creates a stop loss order object which is passed
    % into spot.newOrderO(obj) to request a new stop loss order. A stop
    % loss order can be sell or buy side. Stop-loss orders have a stopPrice
    % which triggers a market order if the current price crosses it. The
    % stop loss trigger condition depends on the order side, ie. buy or
    % sell.
    % Triggers for buy and sell side are as follows:
    %       BUY  side: stopPrice < currentPrice
    %       SELL side: stopPrice > currentPrice
    % Correspondingly, valid stopPrices are:
    %       BUY  side: stopPrice >= currentPrice
    %       SELL side: stopPrice <= currentPrice
    
    properties (Constant = true, Hidden = true)
        orderType   (1,:) char      = 'STOP_LOSS'
    end
    
    properties
        stopPrice   (1,1) double    = 0
    end
    
    methods
        function obj = STOP_LOSS(isIsolated)
            arguments
                isIsolated = false
            end
            obj@sortProps([2:4 1 5:7])
            obj.isIsolated = isIsolated;
        end
    end
end

