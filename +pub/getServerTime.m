function [timestamp] = getServerTime()
% getServerTime returns the current Binance server timestamp.
timestamp = webread('https://api.binance.com/api/v3/time');
timestamp = sprintf('%d',timestamp.serverTime);
end

