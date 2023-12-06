load data_all.mat
load data.mat

%% 4-D

load variable_list.mat

depth = depth(1:57);
lat = 50 : 0.5 : 77;
lon = -170 : 0.5 : 170;

grid = zeros(length(lon), length(lat),length(depth),365);


%2022
data_2022 = data( data(:,1) == 2022,:);

F_lat = data_2022(:,2);
F_lon = data_2022(:,3);
F_dep = data_2022(:,4);
F_temp = data_2022(:,5);
F_sal = data_2022(:,6);
Fdata_2022 = [data_2022(:,7),F_lat,F_lon,F_dep,F_temp,F_sal];

save('Fdata_2022.mat','Fdata_2022')

sum_matrix = [];
count_matrix = 0;
obs_temp = [];

for i = 1 : length(Fdata_2022)

    lat_data(i) = max(find( (lat-F_lat(i)).^2  == min((lat-F_lat(i)).^2)));
    lon_data(i) = max(find( (lon-F_lon(i)).^2 == min((lon-F_lon(i)).^2)));
    depth_data(i) = find( (depth-F_dep(i)).^2 == min((depth-F_dep(i)).^2));

    grid(lon_data(i), lat_data(i), depth_data(i), Fdata_2022(i, 1)) = F_temp(i);

end
nonzero_values = grid(grid ~= 0 & ~isnan(grid));
obs_temp = sum(nonzero_values)/length(nonzero_values);
plot(obs_temp);
save([num2str(2022) '.mat'], "-v7.3",'grid')

%{
lat 70 ~ 79
lon -15 ~ +45
depth 0 ~5 
기간 8~9월
%}

% 연도별 온도가 증가하는지 확인 / plot 으로 
% 윤년 윤달 지워버리고 채우기
% 겹치는 값 평균


%{

idx = find(lat>79) = []
lat1 lon1 - > lat2 lon2
days lat2 lon2 depth t s 
a      b   c    d     e f 
-> 인덱스 넘버로 들어감 

행렬 2개 를 만들어서 저장 하나는 갯수만 하나는 값의 셈 만 넣어놓고 두 행렬을 각각 나눠주면
그게 평균
x축 연도 y축 온도 
lat 70 ~ 79
lon -15 ~ 45
depth 0 ~1
기간 8~9월
%}











