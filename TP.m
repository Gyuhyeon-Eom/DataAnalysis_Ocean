load data_all.mat
load data.mat

%% 4-D 1964~2023

ndays = [0, 31,28,31,30,31,30,31,31,30,31,30,31] ;

for year = 1964 : 2023

    year_data = data(data(:,1) == year, :);
    F_lat = year_data(:, 2);
    F_lon = year_data(:, 3);`
    F_dep = year_data(:, 4);
    F_temp = year_data(:, 5);
    F_sal = year_data(:, 6);     
    F_data = [year_data(:,7),year_data(:,1),F_lat,F_lon,F_dep,F_temp,F_sal];
    save('F_data.mat','F_data')
    clearvars -except F_data & data_all & data

end

load variable_list.mat
