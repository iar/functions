function [ air, shum, level, grid ] = narr_import( date, narrPath )
%NARR_LOAD Loads NARR Reanalysis date, downloads if not available locally
%   Read in netCDF date from Reanalysis
%   Using NARR Reanalysis 3-hour date: http://www.esrl.noaa.gov/psd/date/gridded/date.narr.html
%   ftp://ftp.cdc.noaa.gov/datesets/NARR/pressure/
 %
%   Written By:  Michael Hutchins

    switch nargin
        case 1
            index=1;
            dataPath = textread('dataPath.dat','%s\n');
            path = '';
            pathAlt = '';
            for i = 1 : size(dataPath,1);
                if index == 1 && exist(dataPath{i},'dir')
                    path = dataPath{i};
                    index = index + 1;
                elseif index ==2 && exist(dataPath{i},'dir')
                    pathAlt = dataPath{i};
                end
            end
            narrPath = sprintf('%sNARRfiles/',path);
    end
    
    if length(date) == 1
        date = datevec(date);
        date = date(1:3);
    elseif length(date) == 6
        date = date(1:3);
    end

    %% Check for prelaoded .mat files, otherwise download and import
    
    narrFile = sprintf('%sNARR%04g%02g%02g.mat',narrPath,date);
   
    if exist(narrFile,'file') == 2
        
        load(narrFile(1:end-4))

    else
    
    %% Pick Files

         % Air Temperature @ Pressure Levels
        airName = sprintf('%sair.%04g%02g.nc',narrPath,date(1:2));
         % Specific Humidity @ Pressure Levels
        shumName = sprintf('%sshum.%04g%02g.nc',narrPath,date(1:2));

    %% Check for nc files or download

        ftpServer = 'ftp://ftp.cdc.noaa.gov/NARR/pressure/';

        currentPath = pwd;

        if exist(airName,'file') ~= 2 
            cd(narrPath);
            system(sprintf('wget %sair.%04g%02g.nc',ftpServer,date(1:2)));
            cd(currentPath);
        end

        if exist(shumName,'file') ~= 2
            cd(narrPath);
            system(sprintf('wget %sshum.%04g%02g.nc',ftpServer,date(1:2)));
            cd(currentPath);
        end

    %% Read Variables

        info = ncinfo(airName);

        variables = {info.Variables.Name};

        for i = 1 : length(variables);
            eval(sprintf('%s = ncread(''%s'',''%s'');',variables{i},airName,variables{i}));
        end

        shum = ncread(shumName,'shum');

        variables{end+1} = 'shum';

        % Time is in hours since 1800/01/01
        time = time./24 + 657438;
    
    %% Resave in daily matlab format

        dates = floor(time);
        dates = unique(dates);

        airTotal = air;
        shumTotal = shum;
        timeTotal = time;

        for i = 1 : length(dates)
            date = datevec(dates(i));
            saveName = sprintf('%sNARR%04g%02g%02g.mat',narrPath,date(1:3));
            air = squeeze(airTotal(:,:,:,floor(timeTotal)==dates(i)));
            shum =  squeeze(shumTotal(:,:,:,floor(timeTotal)==dates(i)));
            time = timeTotal(timeTotal == dates(i));
            save(saveName,variables{:});
        end
        
    end
    
    %% Format output varaible grid
    
    grid.lat = lat;
    grid.long = lon;
    grid.time = time;
    grid.x = x;
    grid.y = y;

end

