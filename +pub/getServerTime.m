function [timestamp] = getServerTime()
% getServerTime returns the current Binance server timestamp.
timestamp = webread([getBaseURL '/api/v3/time']);
timestamp = sprintf('%d',timestamp.serverTime);


