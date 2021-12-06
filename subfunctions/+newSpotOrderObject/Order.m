classdef Order < handle & matlab.mixin.SetGet
    % Superclass for each orderType to set up the main components
    
    properties
        symbol              (1,:) char      = []
        side                (1,:) char      = []
        quantity            (1,1) double    = 0
        
        newClientOrderId    (1,:) double    = 0
        isTest              (1,1) logical   = false
        recvWindow          (1,1) double    = 5000
        username            (1,:) char      = 'default'
        
    end
    
    properties (SetAccess = protected, Hidden = true)
        isOCO       (1,1) logical   = false
    end
    
    properties (Dependent = true, Hidden = true)
        endPoint
    end
    
    
    methods (Access = public)
        
        function varargout = send(obj)
           
            s = obj2struct(obj);
            response = sendRequest(s,obj.endPoint,'POST');
            
            if nargout ==0
                disp([ 'Status: ' ...
                    getReasonPhrase(getClass(response.StatusCode)) ])
            elseif nargout == 1
                varargout{1} = response.Body.Data;
            elseif nargout == 2
                varargout = {response.Body.Data,response};
            end
            
        end
        
    end
    
    methods     % Setters and getters.
        
        function set.symbol(obj,symbol)
            obj.symbol = upper(symbol);
        end
        
        function set.side(obj,side)
            assert(contains(side,{'BUY','SELL'},'IgnoreCase',true),...
                'Side must be either ''BUY'' OR ''SELL''')
            obj.side = upper(side);
        end
        
        function set.quantity(obj,quantity)
            obj.quantity = round(quantity,8);
        end
        
        function set.recvWindow(obj,recvWindow)
            assert(recvWindow<=60000 && recvWindow >=1,...
                'recvWindow must be between 1 and 60000 milliseconds')
            obj.recvWindow = recvWindow;
        end
        
        function set.isTest(obj,isTest)
            if obj.isOCO
                warning('OCO''s don''t facilitate test orders')
            else
                obj.isTest = isTest;
            end
        end
        
        function endPoint = get.endPoint(obj)
            
            if obj.isOCO
                endPoint = '/api/v3/order/oco';
                obj.isTest = false;
            elseif obj.isTest
                endPoint = '/api/v3/order/test';
            else
                endPoint = '/api/v3/order';
            end
        end
        
    end
    
    methods ( Access = private )
        
        function s = obj2struct(obj)
            % Converts query parameters in obj to a structure, s, for use
            % with QP = matlab.net.QueryParameters(s) in the obj.send
            % method.
            
            f = fieldnames(obj);
            
            % Omit properties which are not query parameters and which
            % have an indirect conversion (e.g. prices and quantites are 
            % converted to char with %.8f).
            
            idel = ismember(f,...
                {...    % not a query parameter
                'isTest','isQuoteOrderQty','endPoint',...
                ...     % indirect (newOrder params)
                'orderType','quantity','price','stopPrice','icebergQty',...
                ...     % indirect (OCO params)
                'newClientOrderId','stopLimitPrice','limitIcebergQty','stopIcebergQty',...
                'limitClientOrderId','stopClientOrderId'});
            
            f(idel) = [];
            
            % Direct conversion to struct
            for ii = 1:numel(f)
                s.(f{ii}) = obj.(f{ii});
            end
            
            % Include order type (except for OCO's which don't require a 
            % type).
            if ~obj.isOCO
                s.type = obj.orderType;
            end
            
            if isprop(obj,'newClientOrderId') && obj.newClientOrderId ~= 0
                if obj.isOCO
                    s.listClientOrderId = obj.newClientOrderId;
                else
                    s.newClientOrderId = obj.newClientOrderId;
                end
            end     
            
            
            % Note: prices and quantities are initialised in the subclasses
            % as type double equal to zero. The user has to change such
            % properties' values if they're to be included in the query 
            % string.
            
            % quantity
            if obj.quantity ~= 0
                if isprop(obj,'isQuoteOrderQty') && obj.isQuoteOrderQty
                    % Allow up to 8 digit precision
                    s.quoteOrderQty = sprintf('%.8f',obj.quantity);
                    % Remove trailing zeros
                    s.quoteOrderQty = strip(s.quoteOrderQty,'right','0');
                    if s.quoteOrderQty(end) == '.'
                        s.quoteOrderQty(end) = [];
                    end
                else
                    % Allow up to 8 digit precision
                    s.quantity = sprintf('%.8f',obj.quantity);
                    % Remove trailing zeros
                    s.quantity = strip(s.quantity,'right','0');
                    if s.quantity(end) == '.'
                        s.quantity(end) = [];
                    end
                end
            end
            
            % Convert remaining price/quantity props to type char with 8 
            % digit precision in the new structure.
            % Then remove trailing 0's (allows for lower precisions).
            params = {'price','stopPrice','icebergQty','stopLimitPrice',...
                'limitIcebergQty','stopIcebergQty'};
            
            for ii = 1:numel(params)
                if isprop(obj,params{ii}) && obj.(params{ii}) ~= 0
                    % Allow up to 8 digit precision
                    s.(params{ii}) = sprintf('%.8f',obj.(params{ii}));
                    
                    % Remove trailing zeros
                    s.(params{ii}) = strip(s.(params{ii}),'right','0');
                    if s.(params{ii})(end) == '.'
                        s.(params{ii})(end) = [];
                    end
                end
            end
            
            idParams = {'limitClientOrderId','stopClientOrderId'};
            
            for ii = 1:numel(idParams)
                if isprop(obj,idParams{ii}) && obj.(idParams{ii}) ~= 0
                    s.(idParams{ii}) = obj.(idParams{ii});
                end
            end

        end
    end
    
end


