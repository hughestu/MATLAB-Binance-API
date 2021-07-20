function T = repKlines(symbol,interval,timeRange)
% repKlines repeats calls to pub.klines for larger datasets.
%
% T = pub.repKlines(symbol,interval,timeRange) returns the candle data for
% a symbol and interval over a given timeRange, where timeRange has the 
% form: [startTime endTime]. The timeRange can be specified as a datetime 
% or as type double posixtimes in milliseconds. 
%
% Example (get 1 minute data for ETH/BTC for all January 2021): 
%  >> T = pub.repKlines('ethbtc','1m',...
%             [datetime(2021,1,1) datetime(2021,2,1)]);
%

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
    timeRange = datetime(timeRange./1e3,'ConvertF','posixtime','TimeZone','local');
end

numRows = floor(diff(timeRange)./dt); % number of rows to download

[T,w] = pub.klines(symbol,interval,...
    [timeRange(1) timeRange(1)+1000*dt],...
    'limit',1);

T = repmat(T,numRows,1);

s = whos; idx = ismember({s.name},'T');
fprintf('Approx. output array size: %8.2f MB.\n\n',s(idx).bytes*1e-6)


ii = 1;
n = 1000;

while ii*n < numRows                                            %#ok<BDSCI>
    
    fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n',100*((ii-1)*n)/numRows, w(2))
    
    [Ttemp,w] = pub.klines(symbol,interval,...
        [timeRange(1) timeRange(1) + (n-1)*dt]+(ii-1)*n*dt,...
        'limit',n);

    T(1+(ii-1)*n:ii*n,:) = Ttemp;
    
    T.Time(1+(ii-1)*n:ii*n,:) = Ttemp.Time;
    
    ii = ii + 1;

end

n2 = rem(numRows,n);

Ttemp = pub.klines(symbol,interval,...
        [timeRange(1)+(ii-1)*n*dt timeRange(2)],...
        'limit',n2);
        
T(1+(ii-1)*n:(ii-1)*n+n2,:) = Ttemp;
T.Time(1+(ii-1)*n:(ii-1)*n+n2) = Ttemp.Time;

fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n', 100, w(2))

end


