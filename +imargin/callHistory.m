function [d] = callHistory(symbol, OPT)
% callHistory returns history of forced liquidations (margin calls).
%
% imargin.callHistory
%
% imargin.callHistory()
%

arguments
    symbol
    OPT.startTime 	(1,1)
    OPT.endTime 	(1,1)
    
    OPT.limit 		(1,1) double    = 10
    OPT.recvWindow 	(1,:) double    = 5000
    OPT.username (1,:) char      = 'default'
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

endPoint = '/sapi/v1/margin/forceLiquidationRec';
response = sendRequest(OPT,endPoint,'GET');
d = response.Body.Data;

if isstruct(d)
    d = d.rows;
end
