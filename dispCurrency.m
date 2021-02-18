function str = dispCurrency(amt)
    str = fliplr(sprintf('%10.2f',abs(amt)));
    str = regexprep(str,' ','');
    str = str(sort([1:length(str) 7:3:length(str)]));
    str(7:4:length(str)) = ',';
    str = ['$' fliplr(str)];
    if amt<0
        str = ['(' str ')'];
    end   
end