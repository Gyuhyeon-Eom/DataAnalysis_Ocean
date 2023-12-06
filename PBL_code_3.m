    %% 리스트함수를 통한 파일 불러오기
list = dir('/Users/eomgyuhyeon/Library/Mobile Documents/com~apple~CloudDocs/학교/3학년/2학기/PBL/CTD_simple/');

load('variable_list.mat')

% 0.5 x 0.5 , depth 1:1500
lat = 50 : 0.5 :80 ;
lon = -180 : 1 : 180 ;
depth0 = depth(1:57);

load data_all.mat

data2022 = data_all(data_all(:,2) == 2022, :);
data2022(data2022 == -999) = NaN;

month_data = data2022(:,3);
day_data = data2022(:,4);

days_in_month = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
month = [1 2 3 4 5 6 7 8 9 10 11 12];
days = zeros(length(month_data), 1);

for i = 1:length(month_data)

    month = month_data(i);
    day = day_data(i);
    data2022(i,10) = sum(days_in_month(1:month)) + day;

end
%{
Fdata = sortrows(data2022,10);
F_lat = Fdata(:,5)';
F_lon = Fdata(:,6)';
F_depth = Fdata(:,7)';
F_T = Fdata(:,8)';
F_S = Fdata(:,9)';
%}
Fdays = sortrows(data2022,10);
F_lat = Fdays(:,5);
F_lon = Fdays(:,6);
F_depth = Fdays(:,7);
F_T = Fdays(:,8);
F_S = Fdays(:,9);
Fdata = [Fdays(:,10),F_lat,F_lon,F_depth,F_T,F_S];
data_grid = zeros(360, 31, 42, 365);

%{
for i = 1 : length(Fdata)

    lat_data(i) = max(find( (lat-F_lat(i)).^2  == min((lat-F_lat(i)).^2)));
    lon_data(i) = max(find( (lon-F_lon(i)).^2 == min((lon-F_lon(i)).^2)));
    depth_data(i) = find( (depth0-F_depth(i)).^2 == min((depth0-F_depth(i)).^2));
    
end
%}

for i = 1:length(Fdata)

    idx_depth = find( (depth0-F_depth(i)).^2 == min((depth0-F_depth(i)).^2));
    idx_lat = max(find( (lat-Fdata(i,2)).^2  == min((lat-Fdata(i,2)).^2)));
    idx_lon = max(find( (lon-Fdata(i,3)).^2 == min((lon-Fdata(i,3)).^2)));
    data_grid(idx_lon, idx_lat,idx_depth,Fdata(i,1)) = F_depth(i);

end

save([num2str(2022) '.mat'], "-v7.3",'data_grid')

%% 스발바르 제도

% svalbard, 82.5 -> 7
%{
lat 70 ~ 79
lon -15 ~ +45
depth 0 ~5 
기간 8~9월
%}

lat_s = find(F_lat>=70 & F_lat<=79);
lon_s = find(F_lon>=-15 & F_lon<= 45);
depth_s = depth(1:2);

data_grid_s = zeros(360, 31, 42, 365);

for i = 1:length(Fdata)
    idx_depth_s = find( (depth_s-F_depth(i)).^2 == min((depth_s-F_depth(i)).^2));

    idx_lat_s = max(find( (lat_s-Fdata(i,5)).^2  == min((lat_s-Fdata(i,5)).^2)));
    idx_lon_s = max(find( (lon_s-Fdata(i,6)).^2 == min((lon_s-Fdata(i,6)).^2)));
    data_grid_s(idx_lon_s, idx_lat_s,idx_depth_s,Fdata(i,10)) = F_depth(i);

end





















    
