load data_all.mat
load data.mat

%% 4-D 1964~2023

load variable_list.mat

depth = depth(1:57);
lat = 50 : 0.5 : 77;
lon = -170 : 0.5 : 170;

grid = zeros(length(lon), length(lat),length(depth),365);

year1 = (1964:2023);
obs_temp = zeros(1,length(year1));
sum_matrix = zeros(1,length(year1));
count_matrix = zeros(1,length(year1));

for year = 1980 : 2022;

    year_data = data(data(:,1) == year, :);
    F_lat = year_data(:, 2);
    F_lon = year_data(:, 3);
    F_dep = year_data(:, 4);
    F_temp = year_data(:, 5);
    F_sal = year_data(:, 6);     
    F_data = [year_data(:,7),year_data(:,1),F_lat,F_lon,F_dep,F_temp,F_sal];

    save('F_data.mat','F_data')
    disp(year)

    for i = 1 : length(F_data)
        i
        lat_data(i) = max(find( (lat-F_lat(i)).^2  == min((lat-F_lat(i)).^2)));
        lon_data(i) = max(find( (lon-F_lon(i)).^2 == min((lon-F_lon(i)).^2)));
        depth_data(i) = find( (depth-F_dep(i)).^2 == min((depth-F_dep(i)).^2));
        grid(lon_data(i), lat_data(i), depth_data(i), F_data(i, 1)) = F_temp(i);

    end
    save([num2str(year) '.mat'], "-v7.3",'grid')

end




