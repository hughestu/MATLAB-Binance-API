function [T,w] = aggTrades(symbol,varargin,OPT)
% aggTrades returns public aggregated trade data for a specific symbol. 
% Each row of aggregated trade data sumarises the trades which (i) filled  
% at the same time; (ii) were from the same order; and (iii) had the same
% price. The counterpart to this function is pub.historicalTrades which
% gives each individual trade (not aggregated).
%
% T = pub.aggTrades(symbol) returns a timetable with 500 rows of the latest
% aggregated trade data. The output timetable gives time, price, qty and
% the aggregate trade id.
% 
% T = pub.aggTrades(___,'limit',n) returns n rows of the latest aggregated
% trade data for a specific symbol, where n is a value between 1 and 1000.
%
% T = pub.aggTrades(symbol,[startTime endTime]) returns the aggregated
% trade data between a specific startTime and endTime (inclusive). 
% startTime and endTime can be defined as datetimes, or alternatively 
% posixtimes in milliseconds (of type double). The range (endTime -
% startTime) may span up to one hour per api request. A limit number of
% rows to return, n, cannot be defined in combination with a time range.
% Time ranges usually allows significantly more data to be returned per api
% request.  
%
% T = pub.aggTrades(symbol,fromId) returns the aggregated trade data since
% a specific order id, fromId (type double scalar input). (Binance order 
% id's start at 1 and have been incremented by 1 for each trade since that 
% symbol began trading).
%
% Example 1 (get a timetable with 500 rows of the latest aggregated trade 
% data on the BTC/USDT pair):
%  >> T = pub.aggTrades('btcusdt').
%
% Example 2 (get first hour of aggregated trade data for BTC/USDT today):
% >> T = pub.aggTrades('btcusdt',...
%            [datetime('today') datetime('today')+hours(1)]);
%
% Example 3 (get the first 1000 rows of aggregated trade data for some 
% early traded symbols and plot the results):
% >> symbol = {'ltcbtc','bnbbtc','ethbtc','neobtc'};
%    id = 1;
%    for ii = 1:numel(symbol)
%        T = pub.aggTrades(symbol{ii},id,'limit',1000);
%        figure, plot(T.time,T.price)
%        title(symbol{ii}), ylabel(symbol{ii}(4:end))
%        set(gca,'fontSize',16)
%    end

arguments
   symbol           (1,:) char
end

arguments (Repeating)
    varargin
end

arguments
    OPT.limit       (1,1) double
end

import matlab.net.*

assert(nargin>=1 && nargin<=2,sprintf( ['Expected 1 or 2 positional '...
    'input arguments, but %d were given.'], nargin) )

OPT.symbol = upper(symbol);

if nargin == 2
    
    assert( numel(varargin{1}) >= 1 && numel(varargin{1})<=2 , ...
            ['Expected second input argument to have one or two '...
            'elements. Instead it had %d.'],numel(varargin{1}))
        
    % Assign input arg 2 to either OPT.fromId OR OPT.startTime and endTime.
    
    if numel(varargin{1}) == 1
        
        % assign to fromId
        
        assert(isa(varargin{1},'double'),'fromId must be type double.')
        OPT.fromId = varargin{1};
        
    else
        
        % assign to startTime and endTime
        
        assert(~isfield(OPT,'limit'),['Expected either a limiting time'...
            ' range or limit number of rows to return but not both.'])
        
        validateattributes(varargin{1},{'double','datetime'},{'row'})
        t = varargin{1};
        
        if isa(varargin{1},'datetime')
            t = datetime2posix(varargin{1});
        end
        
        OPT.startTime = t(1);
        OPT.endTime = t(2);
        
    end
    
end

% endPoint
endPoint = '/api/v3/aggTrades';
s = sendRequest(OPT,endPoint,'GET');

if abs(s.StatusCode)~=200
    disp(s)
    disp(s.Body.Data)
    T = []; 
    return
end

if isempty(s.Body.Data)
    disp('Valid request but no data')
    T = []; 
    w = getWeights(s);
    return
end

p = double(string({s.Body.Data.p})).';
t = double(string({s.Body.Data.T})).'.*1e-3;
q = str2double({s.Body.Data.q}).';
id = double(string({s.Body.Data.a})).';
time = datetime(t,'ConvertFrom','posix','TimeZone','local');

T = timetable(time,p,q,id,'VariableNames',{'price','qty','id'});

w = getWeights(s);

end

function w = getWeights(s)
idx = find( ismember( [s.Header.Name],...
    ["x-mbx-used-weight","x-mbx-used-weight-1m"] ) );

w = str2double([s.Header(idx).Value]);
end

