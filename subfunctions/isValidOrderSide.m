function [] = isValidOrderSide(orderSide)

orderSides = {'BUY','SELL'};
assert(ismember(upper(orderSide),orderSides),...
    ['Unexpected input for variable, orderSide. Please use one of the following:'...
    sprintf(repmat('\n%s',1,numel(orderSides)),orderSides{:})])