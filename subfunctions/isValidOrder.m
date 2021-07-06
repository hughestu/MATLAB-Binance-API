function [] = isValidOrder(orderType,NV)

orderTypes = {'LIMIT','MARKET','STOP_LOSS','STOP_LOSS_LIMIT',...
    'TAKE_PROFIT','TAKE_PROFIT_LIMIT','LIMIT_MAKER'};

assert(ismember(upper(orderType),orderTypes),...
    ['Unexpected input for variable, orderType. Please use one of the following:'...
    sprintf(repmat('\n%s',1,numel(orderTypes)),orderTypes{:})])

switch orderType
    case 'LIMIT'
        additionalManParams = {'timeInForce','price'};
        assertManParamsIncluded(orderType,additionalManParams,NV)
    case 'MARKET'
        % n/a
    case 'STOP_LOSS'
        additionalManParams = {'stopPrice'};
        assertManParamsIncluded(orderType,additionalManParams,NV)
    case 'STOP_LOSS_LIMIT'
        additionalManParams = {'timeInForce','price','stopPrice'};
        assertManParamsIncluded(orderType,additionalManParams,NV)
    case 'TAKE_PROFIT'
        additionalManParams = {'stopPrice'};
        assertManParamsIncluded(orderType,additionalManParams,NV)
    case 'TAKE_PROFIT_LIMIT'
        additionalManParams = {'timeInForce','price','stopPrice'};
        assertManParamsIncluded(orderType,additionalManParams,NV)
    case 'LIMIT_MAKER'
        additionalManParams = {'price'};
        assertManParamsIncluded(orderType,additionalManParams,NV)
end
end

function [] = assertManParamsIncluded(orderType,additionalManParams,NV)
% asserts that for each order type that additional inputs required for that
% order type have been specified by the user. Otherwise, throws an error
% showing which name-value pair arguments are missing.
fnames = fieldnames(NV);
NVreq = repmat(additionalManParams,2,1); NVreq = NVreq(:);

if isequal(orderType,'MARKET')
    assert(nnz(ismember(additionalManParams,fieldnames(NV)))==1,...
        sprintf(['One of the following name-value pair arguments are required for' ...
        ' %s type orders:',repmat('\n''%s'',%s',1,numel(additionalManParams))],...
        orderType,NVreq{:}))
else
    assert(all(ismember(additionalManParams,fnames)),...
        sprintf(['The following name-value pair arguments are mandatory for' ...
        ' %s type orders:',repmat('\n''%s'',%s',1,numel(additionalManParams))],...
        orderType,NVreq{:}))
end
end