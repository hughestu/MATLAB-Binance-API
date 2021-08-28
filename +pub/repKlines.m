function T = repKlines(symbol,interval,timeRange)
% repKlines repeats calls to pub.klines for larger datasets.
%
% T = pub.repKlines(symbol,interval,timeRange) returns the candle data for
% a symbol and interval over a given timeRange. timeRange can be specified
% as either posixtime in milliseconds or using datetimes.
%
% Note, with datetimes you can specify a TimeZone as follows:
% t = [datetime(2021,1,1) datetime(2021,1,2)]; 
% t.TimeZone = 'Europe/Dublin';
% Alternatively, pub.repKlines uses your 'Local' TimeZone by default.
% Input TimeZones are also applied to the output data, T.
% 
% symbol    - indicates the market, e.g. 'ethbtc'
% interval  - can be any of the following: '1m', '3m', '5m', '15m', '30m', 
%             '1h', '2h', '4h', '6h', '8h', '12h', '1d', '3d', '1w', '1M'.
% timeRange - is specified as [startTime endTime] and can be either a 
% datetime array or type double posixtimes in milliseconds. 
%
% Example (get 1 minute data for ETH/BTC for all January 2021): 
%  >> T = pub.repKlines('ethbtc','1m',...
%             [datetime(2021,1,1) datetime(2021,2,1)]);
%     figure, plot(T.Time,T.open)
%     ylabel('BTC'), title('ETH/BTC'), set(gca,'fontSize',16)

arguments
    symbol      (1,:) char
    interval    (1,:) char
    timeRange
end

validateattributes(timeRange,{'datetime','double'},{'row','numel',2})

intervalTypes = {'1m', '3m', '5m', '15m', '30m', '1h', '2h', '4h', '6h',...
    '8h', '12h', '1d', '3d', '1w', '1M'};

durations = [...
    minutes([1 3 5 15 30]) hours([1 2 3 6 8 12]) days([1 3 7 30])];

idx = ismember(intervalTypes,interval);

assert(any(idx),...
    sprintf( 'Invalid interval, choose one of the following:\n\n%s', ...
    sprintf('%s\n',intervalTypes{:}) )...
    )

dt = durations(idx);


if isa(timeRange,'double')
    timeRange = datetime(timeRange./1e3,'ConvertF','posixtime',...
        'TimeZone','local');
end

tZone = 'local';
if isempty(timeRange.TimeZone)
    timeRange.TimeZone = tZone;
else
    tZone = timeRange.TimeZone;
end

assert(all(timeRange<=datetime('now','TimeZone',tZone)),['Invalid '...
    'timeRange, inputs cannot exceed the present time.'])

ft = datetime(2017,7,14,5,0,0,'TimeZone','utc');
ft.TimeZone = tZone;

assert(all(timeRange>=ft),['Invalid timeRange: timeRange must start on'...
    ' or after %s.'],ft)

maxNumRows = floor(diff(timeRange)./dt); % max number of rows to download

% Note: maxNumRows is used (instead of numRows) because sometimes there are 
% gaps in the data, for example when a symbol's trading status goes on a
% break.
t_null = datetime(0,0,0,'TimeZone',tZone);

T = array2timetable([0,0,0,0,0,0,0],'RowTimes',t_null,...
    'VariableNames',{'open','high','low','close','volume',...
    'quoteVolume','numTrades'});

T = repmat(T,maxNumRows,1);

% display approximate memory requirement
s = whos; idx = ismember({s.name},'T');
fprintf('Approx. output array size: %8.2f MB.\n\n',s(idx).bytes*1e-6)

ii = 1;
n = 1000;
w = [1 1];
t2 = t_null;

while t2 ~= timeRange(2)
    
    fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n',...
        100*((ii-1)*n)/maxNumRows, w(2))
    
    t1 = timeRange(1) + (ii-1)*n*dt;
    t2 = timeRange(1) + (ii-1)*n*dt + (n-1)*dt;
    
    if t2 > timeRange(2)
        t2 = timeRange(2); % loop exit condition
    end
    
    [Ttemp,w] = pub.klines(symbol,interval,[t1 t2],'limit',n);
    
    iStart = find( T.Time == t_null ,1,'first');
    iEnd   = iStart + height(Ttemp) - 1;
    
    if ~isempty(Ttemp)
        T(iStart:iEnd,:) = Ttemp;

        T.Time(iStart:iEnd,:) = Ttemp.Time;
    end
    
    ii = ii + 1;

end

iLeftOver = iEnd + 1;

T( iLeftOver:end , : ) = [];

T.Time.TimeZone = tZone;

fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n', 100, w(2))

end


