function [T,s] = historicalTrades(varargin,OPT)
% historicalTrades returns market trade history for a specific symbol.
%  
% T = pub.historicalTrades(symbol) returns a 500 row timetable of the
% latest trades for a specific symbol (where symbol is a type char row 
% vector).
% e.g. >> T = pub.historicalTrades('btcusdt')
%
% T = pub.historicalTrades(symbol,fromId) returns trades with trade id >= 
% fromId for a specific symbol (the first trade of a symbol's trade history
% has a trade id of 1 and subsequent trade id's are numbered consecutively 
% thereafter).
%
% T = pub.historicalTrades(___,'limit',n) returns n rows of historical
% trade data where n is valid in the range 1-1000 (default: n = 500).
%
% [T,s] = pub.historicalTrades(___) returns the orignal server response
% data as a structure, s.
%
%
% Example 1 (get the first 100 trades recorded on Binance for BNB/BTC):
%  >> T = pub.historicalTrades('bnbbtc',1,'limit',100)
%
%   - remark: In trade number 15 and 20, a total of 14000 BNB sold for 
%             0.14 BTC or an equivalent of $320 at the time. In todays 
%             market (3 years later) 14000 BNB is worth approx. $4,500,000.
%
%
% Example 2 (get the latest 1000 trades for BTC/USDT):
%  >> T = pub.historicalTrades('btcusdt','limit',1000)
% 
%
% Example 3 (scan forwards through trade history for btcusdt, starting from 
% a specific trade id, and store results in a single timetable, TT):
%  >> id = 9.5e8 + 1;     % nominal trade id to start from
%     N = 5;              % loop iterations
%     n = 1000;           % number of trades to receive per api request
%
%     % Preallocate a timetable
%     T = pub.historicalTrades('btcusdt','limit',1);
%     TT = repmat(T,N*n,1); 
% 
%     for ii = 1:N
%         T = pub.historicalTrades('btcusdt',id,'limit',n);
%         TT(1+(ii-1)*n:n*ii,:) = T;
%         T.time(1+(ii-1)*n:n*ii,:) = T.time;
%         id = id + n;
%     end
%
%
% Example 4 (scan backwards through trade history for btcusdt, and store
% results in a single timetable, TT):
%  >> N = 5;              % loop iterations
%     n = 1000;           % number of trades to receive per api request
% 
%     % Preallocate a timetable
%     T = pub.historicalTrades('btcusdt','limit',1);
%     TT = repmat(T,N*n,1); 
%
%     id = T.id;          % most recent trade id
%
%     for ii = 1:N
%         id = id - n;
%         T = pub.historicalTrades('btcusdt',id,'limit',n);
%         TT(1+n*(5-ii):n*(6-ii),:) = T;
%         TT.time(1+n*(5-ii):n*(6-ii),:) = T.time;
%     end

arguments (Repeating)
    varargin
end

arguments     
    OPT.limit   (1,1) double    = 500
end

assert(nargin>=1 && nargin <=2,sprintf(...
    'Expected 1-2 positional input arguments, but there were %d.',nargin))

validateattributes(varargin{1},{'char'},{'row'})
OPT.symbol = upper(varargin{1});

if nargin == 2
    validateattributes(varargin{2},{'double'},{'scalar'})
    OPT.fromId = sprintf('%d',varargin{2});
end

endPoint = '/api/v3/historicalTrades';
response = sendRequest(OPT,endPoint,'GET');

s = response.Body.Data;

if isempty(s)
    T = [];
else
    T = struct2table(s);
    T.price = str2double(T.price);
    T.qty = str2double(T.qty);
    T.quoteQty = str2double(T.quoteQty);

    T.time = datetime(T.time*1e-3,'ConvertF','posixtime',...
        'TimeZone','local');

    T = table2timetable(T,'RowTimes','time');
end
