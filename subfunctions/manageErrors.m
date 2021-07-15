function [] = manageErrors(varargin)
% Error handling for https and server responses. Throws errors for anything
% other than a 200 HTTP status code. Formats server error message and code
% into the error display when they are available.

arguments (Repeating)
    varargin
end


assert(nargin <= 2, sprintf('Expected 1-2 inputs, but there were %d',nargin))
if nargin == 1
    response = varargin{1};
else
    response = varargin{1};
    OPT = varargin{2};
end

sc = response.StatusCode;
try
    % IF ~HTTP200 and SERVER provides msg/code, print HTTPStatus/reason and
    % SERVERcode/msg
    if sc ~= matlab.net.http.StatusCode.OK && isa(response.Body.Data,'struct')...
            && all(ismember({'code','msg'},fieldnames(response.Body.Data)))
        
        if contains(response.Body.Data.msg,'Filter failure') 
            % Case where user input broke a filter rule, this block gets
            % the expected filter conditions (one of which was disobeyed) 
            % and shows them to the user.
            
            % Get filter info for the symbol that the user attempted to
            % make an order with.
            filters = {'PRICE_FILTER','PERCENT_PRICE','LOT_SIZE',...
                'MIN_NOTIONAL','ICEBERG_PARTS','MARKET_LOT_SIZE',...
                'MAX_NUM_ORDERS','MAX_NUM_ALGO_ORDERS'};
            iFilter = cellfun(@(x) contains(response.Body.Data.msg,x),filters);
            filterType = filters{iFilter};
            
            s = pub.exchangeInfo(OPT.symbol);
            iS = ismember(cellfun(@(x) x.filterType,s.symbols.filters,'Uni',false),filterType);
            filterInfo = evalc('disp(s.symbols.filters{iS})');
            
            error(...
                sprintf([ getReasonPhrase(getClass(sc)),': ',getReasonPhrase(sc) '\n'...
                'Server Error Code: ' num2str(response.Body.Data.code) '\n'...
                'Server Message: ' response.Body.Data.msg ...
                sprintf('\n\nCorresponding %s filter:\n%s',OPT.symbol, filterInfo)...
                'For more info on filter errors, see the following <a href = '...
                '"https://binance-docs.github.io/apidocs/spot/en/#filters"'...
                '>documentation</a>.'])...
                )
            
        elseif contains(response.Body.Data.msg,'orders are not supported for this symbol')
            % User attempted to use an order type that the symbol doesn't
            % support - this adds available ordertypes for that symbol and
            % displays them in the error message
            
            s = pub.exchangeInfo(OPT.symbol);

            error(...
                sprintf([ getReasonPhrase(getClass(sc)),': ',getReasonPhrase(sc) '\n'...
                'Server Error Code: ' num2str(response.Body.Data.code) '\n'...
                'Server Message: ' response.Body.Data.msg '\n\n'...
                'The available order types for ' OPT.symbol ' are as follows:\n'...
                sprintf('%s\n',s.symbols.orderTypes{:}) ])...
                )
            
        else
            error(...
                sprintf([ getReasonPhrase(getClass(sc)),': ',getReasonPhrase(sc) '\n'...
                'Server Error Code: ' num2str(response.Body.Data.code) '\n'...
                'Server Message: ' response.Body.Data.msg ])...
                )
        end
        
        % ELSEIF ~HTTP200, print HTTPStatus/reason
    elseif sc ~= matlab.net.http.StatusCode.OK
        error(...
            sprintf([ getReasonPhrase(getClass(sc)),': ',getReasonPhrase(sc)...
            '\nServer Message: N/A'])...
            )
    end
    
catch ME
    
    throwAsCaller(ME)
    
end

end