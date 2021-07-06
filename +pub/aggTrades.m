function [TT,lastId] = aggTrades(symbol,OPT)
% aggTrades returns public trade data for a specific symbol. 

% s = pub.aggTrades('BTCUSDT','startTime',datetime('yesterday'))
arguments
    symbol          (1,:) char      = ''
    OPT.fromId      (1,1) double
    OPT.startTime   (1,1)
    OPT.endTime     (1,1)
    OPT.limit       (1,1) double    = 500
end

import matlab.net.*
symbol = upper(symbol);

if isfield(OPT,'startTime')
    validateattributes(OPT.startTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.startTime,'datetime')
        OPT = datetime2posix(OPT,'startTime');
    end
end

if isfield(OPT,'endTime')
    validateattributes(OPT.endTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.endTime,'datetime')
        OPT = datetime2posix(OPT,'endTime');
    end
end

% baseURL and endPoint
baseURL = 'https://api.binance.com';
endPoint = '/api/v3/aggTrades';
requestMethod = 'GET';

% setup structure for query
OPT.symbol = symbol;

% get queryString
QP = QueryParameter(OPT);
queryString = QP.char;

URL = [baseURL endPoint '?' queryString];

request = http.RequestMessage(requestMethod);
s = request.send(URL);

if abs(s.StatusCode)~=200
    disp(s)
    disp(s.Body.Data)
    TT = []; lastId = [];
    return
end

if isempty(s.Body.Data)
    disp('Valid request but no data')
    TT = []; lastId = [];
    return
end

p = double(string({s.Body.Data.p})).';
t = double(string({s.Body.Data.T})).'.*1e-3;
tn = datetime(t,'ConvertFrom','posix','TimeZone','local');

TT = timetable(tn,p,'VariableNames',{'Price'});

lastId = s.Body.Data(end).a;

