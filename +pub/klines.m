function varargout = klines(symbol,interval,varargin,OPT)
% klines returns candlestick data for a specific symbol and interval.
%
% T = pub.klines(symbol,interval) returns a timetable with 500 rows of
% candlestick data for a specific input symbol (e.g. 'ethbtc') and interval
% which can be any of the following: '1m', '3m', '5m', '15m', '30m', '1h', 
% '2h', '4h', '6h', '8h', '12h', '1d', '3d', '1w', '1M'.
% 
% T = pub.klines(symbol,interval,timeRange) returns the data in a specific
% timeRange which has the form: [startTime endTime]. The timeRange can be 
% specified as a datetime or as type double posixtimes in milliseconds.
%
% T = pub.klines(___,'limit',n) specifies the max. number of rows of data
% to return where n is a value between 1-1000.
%
% [T,w,response] = pub.klines(___) additionally returns the rate limiter
% weights, w, and the full server response.
%
%
% Example 1 (get 1m candlestick data from the last 500 mins on btcusdt):
%  >> T = pub.klines('btcusdt','1m');
%
% Example 2 (get first hour of 1m candlestick data from today for btcusdt)
%  >> T = pub.klines('btcusdt','1m',...
%             [datetime('today') datetime('today')+hours(1)])
%
% Example 3 (get the last 1000 minutes of btcusdt 1 min candlestick data):
%  >> T = pub.klines('btcusdt','1m','limit',1000);
%
% Example 4 (plot candle chart for last 200 days in btcusdt (requires the 
% matlab financial toolbox)):
%  >> d = pub.klines('btcusdt','1d','limit',200);  % get data from Binance.
% 
%     t = tiledlayout(4,1);   % create tiled layout with 4 rows
%     nexttile([3 1])         % give 3/4 rows to candlestick plot
%     candle(d)               % plot candle chart
%     ylabel('BTCUSDT')
%     x = get(gca,'XLim');    % get xlims to use same xlims in the rsi plot
% 
%     nexttile                % give 1/4 rows to rsi plot
%     index = rsindex(d);     % get rsi
%     plot(index.Time,index.RelativeStrengthIndex)
%     set(gca,'XLim',x);      % set xlim to same value as candlestick chart
%     ylabel('RSI')
%     ylim([0 100])


arguments
    symbol          (1,:) char
    interval        (1,:) char
end
arguments (Repeating)
    varargin
end
arguments
    OPT.limit       (1,1) = 500
end

assert(nargin <= 3 && nargin >= 2,...
    sprintf('Expected 2-3 positional input arguments, but was %d.',nargin))

assert(nargout <= 3,'To many output arguments.')

OPT.symbol = upper(symbol);
OPT.interval = interval;

if nargin == 3
    validateattributes(varargin{1},{'datetime','double'},{'row','numel',2})
    t = varargin{1};
    if isa(varargin{1},'datetime')
        t.TimeZone = 'local';
        t = posixtime(t)*1e3;
    end
    OPT.startTime = t(1);
    OPT.endTime = t(2);
end
    
response = sendRequest(OPT,'/api/v3/klines','GET');
w = getWeights(response);

Ta = horzcat(response.Body.Data{:}).';

time = datetime([Ta{:,1}]*1e-3,'ConvertF','posixtime','TimeZone','local').';

OHLCV = cellfun(@str2double,Ta(:,2:6));

quoteVolume = cellfun(@str2double,Ta(:,8));
numTrades = [Ta{:,9}].';

varargout{1} = array2timetable([OHLCV quoteVolume numTrades],'RowTimes',time,...
    'VariableNames',{'open','high','low','close','volume','quoteVolume',...
    'numTrades'});

if nargout == 2
    varargout{2} = w;
elseif nargout == 3
    varargout(2:3) = {w, response};
end
end

function w = getWeights(s)
idx = find( ismember( [s.Header.Name],...
    ["x-mbx-used-weight","x-mbx-used-weight-1m"] ) );

w = str2double([s.Header(idx).Value]);
end