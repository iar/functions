% Traverse Rfile tree and reformat + reorganize

dateRange = datenum([2005,01,01]) : datenum([2013,2,1]);

for i = 1 : length(dateRange);
    date = datevec(dateRange(i));
    r_path = sprintf('/wd2/Rfiles/r%04g/r%04g%02g/',date(1),date(1:2));
    r_day = sprintf('R%04g%02g%02g*',date(1:3));
    r_name =  sprintf('R%04g%02g%02g',date(1:3));
    r_dir = '/wd2/Rfiles/';
    
    
    cd(r_path);
    eval(sprintf('!cat %s >> %s',r_day,r_name));
    eval(sprintf('!mv %s %s',r_name,r_dir));
    
    dateNext = datevec(dateRange(i+1));
    if date(2) ~= dateNext(2)
        !gzip R* &
    end
    
    cd(r_dir)
    data = r_import(r_name);
    save(r_name,'data');
    clear data
    
end