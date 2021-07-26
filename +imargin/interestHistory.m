function T = interestHistory(varargin,symbol,OPT)
% interestHistory returns interest history on loans.
%
% imargin.interestHistory()
%
% imargin.interestHistory(asset,timeRange)

arguments (Repeating)
    varargin
end

arguments
    symbol
    OPT.startTime 	(1,1)
    OPT.endTime 	(1,1)
    
    OPT.limit 		(1,1) double    = 10
    OPT.archived 	(1,1) logical   = false
    OPT.recvWindow 	(1,:) double    = 5000
    OPT.username (1,:) char      = 'default'
end

assert(nargin <= 2, ...
    sprintf('Expected 1 - 2 input arugments, but there were %d.',nargin));


if nargin >= 1
    validateattributes(varargin{1},{'char'},{'row'})
    OPT.asset = upper(varargin{1});
end

OPT.isolatedSymbol = upper('symbol');

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
