folderPath = '/Users/eomgyuhyeon/Library/Mobile Documents/com~apple~CloudDocs/학교/3학년/2학기/PBL/ssp245'; 
year = 1850 : 2100 ; 

amocFiles = dir(fullfile(folderPath, 'AMOC*.txt'));

icexFiles = dir(fullfile(folderPath, 'icex*'));

amoc_mean = zeros(251, length(amocFiles));

figure('Position', [10 10 1200 600])

legendNames = {};

for i = 1:length(amocFiles)

    currentFile = amocFiles(i).name;
    amoc_data = load(fullfile(folderPath, currentFile));
    amoc_mean(:,i) = mean(amoc_data, 2); 
    legend_labels_amoc{i} = strrep(strrep(currentFile, 'AMOC_CMIP6_', ''), '_ssp245_1850-2100_J_D_MYM.txt', '');

end

icex_mean = zeros(251, length(icexFiles));


for i = 1:length(icexFiles)

    currentFile = icexFiles(i).name;
    icex_data = load(fullfile(folderPath, currentFile));
    icex_mean(:,i) = mean(icex_data, 2); 

end

amoc_ensemble_mean = zeros();
icex_ensemble_mean = zeros();

for i = 1 : 251

    amoc_ensemble_mean(i) = mean(amoc_mean(i,:));
    icex_ensemble_mean(i) = mean(icex_mean(i,:));
    
end


subplot(1,2,1);
plot(year,amoc_mean);
title('AMOC Index(Annual mean)')
xlabel('Year')
ylabel('AMOC Index[Sv]')
hold on;
grid on;

subplot(1,2,2)
hold on;
grid on;
plot(year,icex_mean);
plot(year, icex_ensemble_mean, 'k-', 'LineWidth', 2);
title('Sea Ice Extent (Annual mean)')
xlabel('Year')
ylabel('Ice extent in NH [10^6km^2]')
    
legend(legend_labels_amoc, 'FontSize', 6, 'Location', 'east');

%%

index_1980 = find(year == 1980);
index_2020 = find(year == 2020);
index_2050 = find(year == 2050);
index_2060 = find(year == 2060);

amoc_strength_1980_2050 = amoc_mean(index_1980:index_2050, :);
amoc_mean_1980_2050 = mean(amoc_strength_1980_2050, 1);
icex_strength_1980_2050 = icex_mean(index_1980:index_2050, :);

dICEX_dt_1980_2050 = (icex_mean(index_2050, :) - icex_mean(index_1980, :)) / (2050 - 1980);
dAMOC_dt_1980_2050 = (amoc_mean(index_2050, :) - amoc_mean(index_1980, :)) / (2050 - 1980);

%%
delta_AMOC = dAMOC_dt_1980_2050;
delta_Fv = zeros(251, 1);
A = 1;
for i = 1:251
    if year(i) <= 2015
        delta_Fv(i) = 34.7 * (-9.250e-5) / A * (year(i) - 1980);
    else
        delta_Fv(i) = 34.7 * (-9.250e-5) / A * (year(i) - 1980) + 34.7 * (-3.729e-5) / A * (year(i) - 2015);
    end
end

figure;

subplot(2, 1, 1);
delta_ICEX = dICEX_dt_1980_2050;
plot( detrend(delta_ICEX), 'b', 'LineWidth', 2);
title('Delta ICEX (1980 - 2050)');
xlabel('Year');
ylabel('Delta ICEX');
grid on;

subplot(2, 1, 2);
plot(delta_Fv, 'g', 'LineWidth', 2);
title('Delta Fv (1980 - 2100)');
xlabel('Year');
ylabel('Delta Fv');
grid on;


%%
y = 2.406 * 10^4 * exp(-0.0036 * year);
figure;
plot(year, amoc_ensemble_mean, 'b-', 'LineWidth', 2); % 앙상블 평균
hold on;
plot(year, y, 'r--', 'LineWidth', 2); % fitting된 곡선
title('AMOC Index (Annual mean) with Fitted Curve')
xlabel('Year')
ylabel('AMOC Index [Sv]')
legend('Ensemble Mean', 'Fitted Curve', 'Location', 'northwest')
grid on;

%%

smoothed_amoc_mean = smoothdata(amoc_mean, 'movmean', 10); 
amoc_rate_of_change = diff(smoothed_amoc_mean) ./ diff(year');
figure;
subplot(2,1,1);
plot(smoothed_amoc_mean);
subplot(2,1,2);
plot(year(2:end), amoc_rate_of_change, 'm', 'LineWidth', 2);
title('AMOC Rate of Change');
xlabel('Year');
ylabel('AMOC Rate of Change');
grid on;


%%
figure;

subplot(2, 1, 1);
plot(detrend(delta_ICEX), 'b', 'LineWidth', 2);
title('Additional Delta ICEX (1980 - 2050)');
xlabel('Year');
ylabel('Delta ICEX');
grid on;

subplot(2, 1, 2);
plot(detrend(delta_AMOC), 'r', 'LineWidth', 2);
title('Additional Delta AMOC (1980 - 2050)');
xlabel('Year');
ylabel('Delta AMOC');
grid on;
%%

amoc_increment = diff(amoc_ensemble_mean);
year_increment = year(2:end);  

icex_increment = diff(icex_ensemble_mean);

figure;
subplot(1,2,1)
plot(year_increment, amoc_increment);
title('AMOC Increment Rate');
xlabel('Year');
ylabel('AMOC Increment');

subplot(1,2,2)
plot(year_increment, icex_increment);
title('Sea Ice Increment Rate');
xlabel('Year');
ylabel('Sea Ice Increment');


%% 증감률

window_size = 27;
num_windows = floor(size(amoc_mean, 1) / window_size);
amoc_trends = zeros(num_windows, size(amoc_mean, 2));

for i = 1:size(amoc_mean, 2)
    amoc_model_data = amoc_mean(:, i);
    for j = 1:num_windows
        start_idx = (j - 1) * window_size + 1;
        end_idx = start_idx + window_size - 1;
        window_data = amoc_model_data(start_idx:end_idx);
        trend = (window_data(end) - window_data(1)) / window_data(1);
        amoc_trends(j, i) = trend;
    end
end

figure;
boxplot(amoc_trends, 'Labels', legend_labels_amoc);
title('AMOC Trends per Model (27-year intervals)');
xlabel('Model');
ylabel('Trend');

%{
sea ice를 amoc에 들어온 sea ice 면적만 따로 뽑아 쓴다. 
일반적인 sea ice로는 판단이 힘듦
smoothing 한번

최근 관측에서 보이는 AMOC 감소가 CMIP6 모형에서 보이는 감소보다 훨씬 큰건지, 통계적으로 유의한지 판단해볼수 있을까요?

각 모델의 amoc_mean 데이터의 증감률을 27년단위로 끊어서 boxplot으로 plot해보기 
관측 값은 딱 한개, 모델은 값이 총 37개있음 
모델 하나마다 138개의 자료가 나온다.
%}




