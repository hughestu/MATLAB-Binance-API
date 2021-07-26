function T = transferHistory(symbol,varargin,OPT)
% transferHistory returns a list of transfers in and out of isolated margin.
%
% imargin.transferHistory(symbol) returns the latest transfers between spot
% and isolated margin accounts; by default, the response includes data from
% the last 7 days and up to 10 rows of data. You can specify a different
% number of rows using the 'limit',n name-value pair argument (this is
% still restricted to the last 7 days).
%
% imargin.transferHistory(symbol,direction) returns the transfer history
% for a specific symbol and direction. Direction specifies transfers that
% were either (i) transferred 'in' or (ii) transferred  'out' of the 
% isolated margin account. e.g. >> imargin.transferHistory('btcusdt','in')
%
% imargin.transferHistory(___,'limit',n) specifies the number of rows,
% n, to return; default: 10; valid range: 1-100. Note, to return data
% outside of the last week use the 'startTime',t or 'endTime',t name-value 
% pairs.
%
% imargin.transferHistory(___,'startTime',t) returns transfer history
% since a specific startTime, t, where t is a datetime or type double
% posixtime in milliseconds.
%
% imargin.transferHistory(___,'endTime',t) returns transfer history up
% to a specific endTime, t.
%
% imargin.transferHistory(___,'archived',tf) returns archived transfer
% data from beyond 6 months.
%
% Additional name-value arguments:
%   'recvWindow',t          request timeout window (1 <= t <= 60000).
%   'username',name         specifies the username (see getkeys.m).
%
% Example 1, request up to 20 rows of transfer history from the last week:
%  >> imargin.transferHistory('limit',20)
%
% Example 2, request the latest 100 rows of transfer history data:
%  >> imargin.transferHistory('endTime',datetime(),'limit',100);

arguments
    symbol (1,:) char
end

arguments (Repeating)
    varargin
end

arguments
    OPT.limit       (1,1) double    = 10
    OPT.startTime   (1,1)
    OPT.endTime     (1,1)
    OPT.archived 	(1,1) logical   = false
    OPT.recvWindow  (1,1) double    = 5000
    OPT.username (1,:) char      = 'default'
end

assert(nargin<=3,sprintf(...
    'Expected 1-3 positional input arguments, but there were %d.',nargin));


OPT.symbol = upper(symbol);


if nargin == 2 && ~isempty(varargin{1})
    
    validateattributes(varargin{1},{'char'},{'row'})
    
    idx = ismember({'in','out'},varargin{1});
    
    assert(any(idx),['Input argument, type, should either be ''toSpot'''...
        ' or ''toMargin'''])
    
    transTo = {'ISOLATED_MARGIN','SPOT'};
    OPT.transTo = transTo{idx};
    OPT.transFrom = transTo{~idx};
end

assert( sum(isfield(OPT,{'startTime','endTime'})) ~= 2,...
    'Cannot specify a startTime AND endTime.')

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

assert(OPT.limit >= 1 && OPT.limit <= 100,sprintf( ...
    ['Expected the number of rows, n, in the name-value argument, '...
    '''limit'',n,\nto be a value between 1-100. Instead, it was %d.'],...
    OPT.limit))

% Change limit to its corresponding server fieldname: size (limit is
% consisistent with other endPoints).
OPT.size = OPT.limit;
OPT = rmfield(OPT,{'limit'});

endPoint = '/sapi/v1/margin/isolated/transfer';
response = sendRequest(OPT,endPoint,'GET');

s = response.Body.Data;

% output formatting
if ~isempty(s) && ~isempty(s.rows)
    
    if height(s.rows) == 1
        T = struct2table(s.rows,'AsArray',true); % requirement for scalar s
    else
        T = struct2table(s.rows);
    end
    
    T.timestamp = datetime(T.timestamp/1e3,...
        'ConvertF','posix','TimeZ','local');
    
    T.Properties.VariableNames{1} = 'time';
    T = table2timetable(T);
    
else
    T = [];
end


