function T = repAggTrades(symbol,timeRange)
% repAggTrades repeats calls to pub.aggTrades for larger datasets.
%
% T = pub.repAggTrades(symbol,timeRange) returns aggregated trade data for
% a specific symbol and timeRange where symbol is a type char row vector
% and timeRange is a 1 by 2 datetime array. The timeRange can be any
% duration.
%
% Example (download btcusdt data from the last 24hrs):
%  >> T = pub.repAggTrades('btcusdt',[datetime()-days(1) datetime()]);

arguments
    symbol (1,:) char
    timeRange (1,2) datetime
end

% Get sample data to determine the first and last trades inside the user  %
% defined timeRange.                                                      %

fprintf('Fetching start/end times from server...\n\n')

firstTrades = [];
dt = hours(0);

if isempty(timeRange.TimeZone)
    timeRange.TimeZone = 'local';
end

% Most times these loops wont loop, but occasionally theres no data even in
% a full hour - Binance often puts a symbols trading status on 'BREAK'.
while isempty(firstTrades) && timeRange(1)+hours(1)+dt < timeRange(2)
    firstTrades = pub.aggTrades(symbol,...
        [timeRange(1) timeRange(1)+hours(1)]+dt);
    dt = dt+hours(1);
end

lastTrades = [];
dt = hours(0);
if ~isempty(firstTrades)
    while isempty(lastTrades) && timeRange(2)-hours(1)-dt > timeRange(1)
        [lastTrades,w] = pub.aggTrades(symbol,...
            [timeRange(2)-hours(1) timeRange(2)]-dt);
        dt = dt+hours(1);
    end
end 

assert(~isempty(firstTrades),sprintf(...
    'No trade data exists in between %s and %s for %s',...
    char(timeRange(1)), char(timeRange(2)), symbol))

totalIdRange = [firstTrades.id(1) lastTrades.id(end)];
totalTimeRange = [firstTrades.Time(1) lastTrades.Time(end)];


% Decide to use either fromId or a timerange (startTime AND endTime).
% The option that returns more rows of data per api request is selected.
% The max rows of data returned using pub.aggTrades(symb,id,limit=1000)
% is 1000, and the max timerange per api request is 1 hr. Therefore, when
% tradesPerHour exceeds 1000, rep.AggTrades uses timeranges since it
% returns more data per api reqest than &limit=1000.

tradesPerHour = diff(totalIdRange)/hours(timeRange(2)-timeRange(1));

r = getRateLimits();    % local function

T = repmat(firstTrades(1,:),diff(totalIdRange)+1,1);    % preallocate

% Show memory requirement for T.
s = whos; idx = ismember({s.name},'T');
fprintf('Approx. output array size: %8.2f GB.\n\n',s(idx).bytes*1e-9)

if tradesPerHour > 1000
    % Time range approach
    
    fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n',0, w(2))
    idx = 1;
    
    t1 = totalTimeRange(1);
    
    while t1 < totalTimeRange(2)
        
        if t1 + hours(1) >= totalTimeRange(2)
            t2 = totalTimeRange(2);
        else
            t2 = t1 + hours(1);
        end
        
        % Rate limits
        if any(w(2) > r - 10)
            fprintf('Approaching rate limits - pausing for 10 seconds...')
            pause(10)
        end
        
        [Ttemp,w] = pub.aggTrades(symbol,[t1 t2]);
        
        if isempty(Ttemp)
            t1 = t2; % and no update to T
        else
            T( idx : idx+size(Ttemp,1)-1, : ) = Ttemp;
            T.Time( idx : idx+size(Ttemp,1)-1 ) = Ttemp.Time;
            idx = idx + size(Ttemp,1) - 1;
            t1 = Ttemp.Time(end);
        end
        
        fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n',...
            100*idx/(diff(totalIdRange)+1), w(2))
        
    end
    
else
    % fromId approach
    
    idStart = totalIdRange(1);
    idx = 1;
    
    while idStart <= totalIdRange(2)
        
        if idStart + 1000 >= totalIdRange(2)
            n = totalIdRange(2) - idStart + 1;
        else
            n = 1000;
        end
        
        % Rate limits
        if any(w(2) > r - 10)
            fprintf('Approaching rate limits - pausing for 10 seconds...')
            pause(10)
        end
        
        [Ttemp,w] = pub.aggTrades(symbol,idStart,'limit',n);
        
        T(idx:idx+size(Ttemp,1)-1,:) = Ttemp;
        T.Time(idx:idx+size(Ttemp,1)-1) = Ttemp.Time;
        
        idStart = idStart + 1000;
        
        fprintf('Loading: %8.1f%%   (Limiter weight - %3d)\n',...
            100*(idx+size(Ttemp,1)-1)/(diff(totalIdRange)+1), w(2))
        
        idx = idx + 1000;
        
    end
    
end

end

function r = getRateLimits()
% returns the most restricting rate limit on a request per minute basis.

s = pub.exchangeInfo(); % get rate limits
s = s.rateLimits;

idx = ismember({s.rateLimitType},'REQUEST_WEIGHT');
requestWeightLimit = struct2cell( s(idx) );

idx = ismember({s.rateLimitType},'RAW_REQUESTS');
rawRequestLimit = struct2cell( s(idx) );

assert(isequal( rawRequestLimit(1:3),{'RAW_REQUESTS';'MINUTE'; 5}) &&...
    isequal( requestWeightLimit(1:3),{'REQUEST_WEIGHT';'MINUTE'; 1}),...
    'A rate limit definition has changed - FEX submission requires update')

rWeight = requestWeightLimit{4}/requestWeightLimit{3}; % per min
rRaw = rawRequestLimit{4}/rawRequestLimit{3}; % per min

r = min([rWeight rRaw]);
end
