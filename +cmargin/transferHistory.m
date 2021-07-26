function T = transferHistory(varargin,OPT)
% transferHistory returns a list of transfers in and out of cross margin.
%
% cmargin.transferHistory() returns the latest transfers between spot and
% cross margin accounts; by default, the response includes data from the 
% last 7 days and up to 10 rows of data. You can specify a different number 
% of rows using the 'limit',n name-value pair argument (this is still
% restricted to the last 7 days).
%
% cmargin.transferHistory(asset,direction) returns the transfer history for
% a specific asset and direction. Direction specifies transfers that were
% (i) transferred 'in' or (ii) transferred  'out' of the cross margin
% account. e.g. >> cmargin.transferHistory('btc','in')
%
% cmargin.transferHistory([],direction) returns the latest 10 transfers for 
% any asset 'in' or 'out' of the cross margin account, which occured in the
% last 7 days.
%
% cmargin.transferHistory(___,'limit',n) specifies the number of rows, n, to
% return; default: 10; valid range: 1-100. Note, to look back more than 7
% days use the 'startTime',t or 'endTime',t name-value pairs.
%
% cmargin.transferHistory(___,'startTime',t) returns transfer history since 
% a specific startTime, t, where t is a datetime or type double posixtime
% in milliseconds.
%
% cmargin.transferHistory(___,'endTime',t) returns transfer history up to a 
% specific endTime, t.
%
% cmargin.transferHistory(___,'archived',tf) returns archived transfer data
% from beyond 6 months.
%
% Example 1: request up to 100 rows of transfer history for the previous
% month
%  >> T = cmargin.transferHistory('startTime',datetime()-days(30),...
%             'limit',100);

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

if nargin >= 1 && ~isempty(varargin{1})
    validateattributes(varargin{1},{'char'},{'row'})
    OPT.asset = upper(varargin{1});
end

if nargin == 2 && ~isempty(varargin{2})
    validateattributes(varargin{2},{'char'},{'row'})
    
    idx = ismember({'in','out'},varargin{2});
    
    assert(any(idx),...
        'Input argument, direction, should either be ''in'' or ''out''')
    
    directions = {'ROLL_IN','ROLL_OUT'};
    OPT.type = directions{idx};
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

% Convert limit to its corresponding server fieldname.
OPT.size = OPT.limit;
OPT = rmfield(OPT,'limit');

endPoint = '/sapi/v1/margin/transfer';
response = sendRequest(OPT,endPoint,'GET');
s = response.Body.Data;

% output formatting
if ~isempty(s) && ~isempty(s.rows)
    
    T = struct2table(s.rows,'AsArray',true);

    T.timestamp = datetime(T.timestamp/1e3,...
        'ConvertF','posix','TimeZ','local');
    
    T.Properties.VariableNames{1} = 'time';
    T = table2timetable(T);
    
else
    T = [];
end

