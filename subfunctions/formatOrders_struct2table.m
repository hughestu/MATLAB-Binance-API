function t = formatOrders_struct2table(s)
t = struct2table(s);
fnames = fieldnames(s);
for c = [5:8 13 14 18]
    t.(fnames{c}) = cellfun(@str2double,t.(fnames{c}));
end
for c = [1 4 9:12]
    t.(fnames{c}) = cellfun(@string,t.(fnames{c}));
end
t.time = datetime(t.time./1000,'ConvertFrom','posixtime');
t.updateTime = datetime(t.updateTime./1000,'ConvertFrom','posixtime');
end