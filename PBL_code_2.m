%% 리스트함수를 통한 파일 불러오기
list = dir('C:\Users\turtl\iCloudDrive\학교\3학년\2학기\PBL\CTD_simple\');

load('variable_list.mat')

% 0.5 x 0.5 , depth 1:1500
lat = 50 : 0.5 :80 ;
lon = -180 : 0.5 : 180 ;
depth0 = depth(1:57);

data_all = []; % 빈 행렬 생성

for i = 3:length(list)
    file_name = "C:\Users\turtl\iCloudDrive\학교\3학년\2학기\PBL\CTD_simple\"+list(i).name; % 파일 이름 생성
    
    data0 = readtable(file_name); % 해당 파일 불러오기
    data = table2array(data0); % table형식에서 배열형식으로 변경

    data_all = [data_all; data]; % 하나씩 불러와서 이어붙이기
end

data_year = DataCom.(['data' num2str(year)]);

lat_year = data_year(:,2);
lon_year = data_year(:,3);
depth_year = data_year(:,4);

for i = 1 : length(data_year)

    lat_data(i) = max(find( (lat-lat_year(i)).^2  == min((lat-lat_year(i)).^2)));
    lon_data(i) = max(find( (lon-lon_year(i)).^2 == min((lon-lon_year(i)).^2)));
    depth_data(i) = find( (depth0-depth_year(i)).^2 == min((depth0-depth_year(i)).^2));

end

data_1 = rmmissing(data_all);

yearColumn = 2;

yearlyData = struct;

monthlyData = struct;

DataCom = struct;

for year = 1980:2022

    yearData = data_1(data_1(:, yearColumn) == year, :);
    
    yearData(yearData == -999) = NaN;
    
    yearlyData.(['data' num2str(year)]) = yearData;

    yearlyDataYear = yearlyData.(['data' num2str(year)]);

% MM DD -> days
    month_data = yearlyDataYear(:, 3);
    day_data = yearlyDataYear(:, 4);
    
    days_in_month = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    months = [1 2 3 4 5 6 7 8 9 10 11 12];
    days = zeros(length(month_data), 1);

    for i = 1:length(month_data)
        month = month_data(i);
        day = day_data(i);
        days(i) = sum(days_in_month(1:month)) + day;
    end

    monthlyData.(['data' num2str(year)]) = days;

    yearlyDataYear = yearlyData.(['data' num2str(year)]);
    monthlyDataYear = monthlyData.(['data' num2str(year)]);

    data_lat = yearlyDataYear(:, 5);
    data_lon = yearlyDataYear(:, 6);
    data_depth = yearlyDataYear(:, 7);

    data_days = monthlyDataYear;
    data_com = [data_days, data_lat, data_lon, data_depth];

    DataCom.(['data' num2str(year)]) = data_com;

end


grid = zeros(length(lat), length(lon), length(depth0), 365);

for year = 1980:2022

    lagrange_data = DataCom.(['data' num2str(year)]);
    
    for i = 1:size(lagrange_data, 1)
        lat_value = lagrange_data(i, 2);
        lon_value = lagrange_data(i, 3);
        depth_value = lagrange_data(i, 4);
        data_value = lagrange_data(i, 1);




        grid(lat_index, lon_index, depth_index, days(i)) = data_value;
    end

    save([num2str(year) '.mat'], 'grid');
end

%% 스발바르 제도

% svalbard, 82.5 -> 7
%{
lat 70 ~ 79
lon 15 ! 45
depth 0 ~5 
기간 8~9월
%}

lat_s = find(F_lat>=70 & F_lat<=79);
lon_s = find(F_lon>=15 & F_lon<= 45);
depth_s = depth(1:2);

data_grid_s = zeros(360, 31, 42, 365);

for i = 1:length(Fdata)
    idx_depth_s = find( (depth_s-F_depth(i)).^2 == min((depth_s-F_depth(i)).^2));

    idx_lat_s = max(find( (lat_s-Fdata(i,5)).^2  == min((lat_s-Fdata(i,5)).^2)));
    idx_lon_s = max(find( (lon_s-Fdata(i,6)).^2 == min((lon_s-Fdata(i,6)).^2)));
    data_grid_s(idx_lon_s, idx_lat_s,idx_depth_s,Fdata(i,10)) = F_depth(i);

end


% 연도별 온도가 증가하는지 확인 / plot 으로 
% 윤년 윤달 지워버리고 채우기
% 겹치는 값 평균




































