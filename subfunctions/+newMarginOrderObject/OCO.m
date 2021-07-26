classdef OCO < newMarginOrderObject.Order & sortProps
    % OCO is an object for making One Cancels the Other (OCO) orders. An 
    % OCO allows you to place two orders at the same time. It combines a 
    % limit order with a stop-limit order, but only one of the two can be
    % executed. As soon as one order gets partially or fully filled, the
    % remaining one will be canceled automatically. Additionally, 
    % cancelling one of the orders will also cancel the other.
    %
    % Mandatory parameters:
    %   symbol
    %   side
    %   quantity
    %   price (a.k.a. the limit price)
    %   stopPrice
    %   stopLimitPrice
    %
    % Optional parameters:
    %   newClientOrderId
    %   stopClientOrderId 
    %   limitIcebergQty
    %   stopClientOrderId
    %   stopLimitTimeInForce
    %   isTest
    %   recvWindow
    %   username
    
    properties
        price                   (1,1) double    = 0
        stopPrice               (1,1) double    = 0
        stopLimitPrice          (1,1) double    = 0
        
        limitClientOrderId      (1,1) double    = 0
        stopClientOrderId       (1,1) double    = 0
        
        limitIcebergQty         (1,1) double    = 0
        stopIcebergQty          (1,1) double    = 0
        
        stopLimitTimeInForce    (1,:) char      = 'GTC'
    end
    
    methods
        function obj = OCO
            obj@sortProps([9:11 1:3 12 4:8 13:14])
            obj.isOCO = true;
        end
       
    end
end

