function t = formatOrders_struct2table(s)
t = struct2table(s);
fnames = fieldnames(s);

if height(t) > 1
    for c = [5:8 13 14 18]
        t.(fnames{c}) = cellfun(@str2double,t.(fnames{c}));
    end
    for c = [1 4 9:12]
        t.(fnames{c}) = cellfun(@string,t.(fnames{c}));
    end
else
    for c = [5:8 13 14 18]
        t.(fnames{c}) = cellfun(@str2double,{t.(fnames{c})});
    end
    for c = [1 4 9:12]
        t.(fnames{c}) = cellfun(@string,{t.(fnames{c})});
    end
end
t.time = datetime(t.time./1000,'ConvertFrom','posixtime');
t.updateTime = datetime(t.updateTime./1000,'ConvertFrom','posixtime');
end