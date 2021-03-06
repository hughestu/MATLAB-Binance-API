function [] = isValidTimeInForce(TimeInForce)

TimesInForce = {'GTC','IOC','FOK'};
timeInForceError = {'GTC - Good Til Canceled', 'IOC - Immediate Or Cancel',...
    'FOK - Fill Or Kill'};
assert(ismember(upper(TimeInForce),TimesInForce),...
    ['Unexpected input for variable, timeInForce. Please use one of the following:'...
    sprintf(repmat('\n%s',1,numel(TimesInForce)),timeInForceError{:})])