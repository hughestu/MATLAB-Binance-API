function isValidSymbol(symbol)
load symbols.mat
assert(ismember(symbol,{symbols.symbol}),sprintf('Invalid trading pair: %s',symbol))
end


