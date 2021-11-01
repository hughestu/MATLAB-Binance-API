function T = interestHistory(symbol,varargin,OPT)
% interestHistory returns interest history on loans.
%
% imargin.interestHistory(symbol)
%
% imargin.interestHistory(___,asset)
%
% imargin.interestHistory(___,'startTime',t1) requests interestHistory from
% a specific startTime, which is either a type double posixtime in
% milliseconds, or a datetime type.
%
% imargin.interestHistory(___,'startTime',t1,'endTime',t2) request
% interestHistory within the timerange t1 to t2. You may also solely
% specify an endTime.
%
% Example: 
%   >> imargin.interestHistory('btcusdt','startTime',datetime(2017,9,1))
%   >> imargin.interestHistory('btcusdt','usdt','startTime',datetime(2017,9,1))


arguments
    symbol
end
arguments (Repeating)
    varargin
end
arguments
    OPT.startTime 	(1,1)
    OPT.endTime 	(1,1)
    
    OPT.limit 		(1,1) double    = 10
    OPT.archived 	(1,1) logical   = false
    OPT.recvWindow 	(1,:) double    = 5000
    OPT.username (1,:) char      = 'default'
end

assert(nargin <= 3, ...
    sprintf('Expected 1 - 3 input arugments, but there were %d.',nargin));

if nargin >= 2
    validateattributes(varargin{1},{'char'},{'row'})
    OPT.asset = upper(varargin{1});
end

OPT.isolatedSymbol = upper(symbol);

if isfield(OPT,'startTime')
    validateattributes(OPT.startTime,{'double','datetime'},{})
    if isa(OPT.startTime,'datetime')
        OPT = datetime2posix(OPT,'startTime');
    end
end

if isfield(OPT,'endTime')
    validateattributes(OPT.endTime,{'double','datetime'},{})
    if isa(OPT.endTime,'datetime')
        OPT = datetime2posix(OPT,'endTime');
    end
end

OPT.size = OPT.limit;
OPT = rmfield(OPT,'limit');

endPoint = '/sapi/v1/margin/interestHistory';
response = sendRequest(OPT,endPoint,'GET');
d = response.Body.Data;

if isa(d,'struct') && isa(d.rows,'struct')
    T = struct2table(d.rows,'AsArray',true);
else
    T = [];
end


end
