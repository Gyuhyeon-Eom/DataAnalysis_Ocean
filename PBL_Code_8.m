folderPath = '/Users/eomgyuhyeon/Library/Mobile Documents/com~apple~CloudDocs/학교/3학년/2학기/PBL/ssp245'; 
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
figure;
plot(year,amoc_ensemble_mean)

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


%{
디트렌드 경향성 제거이후 fft
현재 강도가 강한 모형일수록 미래 기후변하의 감소율이 클것인가? 
현재 sea ice 감소 경향성을 리그레이드 했을때 현재 amoc감소와 크게 다르지 않은 데이터를
걸러냈을경우 
필요한 데이터 -> 강우량....
amoc의 악화 원인
-> 바다의 성층 강화, 바다의 표면의 밀도가 낮아짐-> 바다의 안정화
->물이 층강이 안됨 -> 열염순환 약화
1980년~2020년  40년동안의 amoc이 강한 모형일 수록 더 많이 줄어들었는가? amoc의 평균 강도를 
회귀식의 기울기 * 40 
ode 2개를 커플시켜서 시뮬레이션

y축 델타 sea_ice, x축 37개의 amoc 평균
y축 2020~2060년까지의 amoc감소율, x축 1980년부터 2020년까지의 amoc평균
|corr| > 0.4 -> 좋은 상관관계
모든 분석을 연평균으로 
%}


index_1980 = find(year == 1980);
index_2020 = find(year == 2020);
index_2050 = find(year == 2050);
index_2060 = find(year == 2060);

%% dAMOC/dt 
amoc_strength_1980_2050 = amoc_mean(index_1980:index_2050, :);
amoc_mean_1980_2050 = mean(amoc_strength_1980_2050, 1);
icex_strength_1980_2050 = icex_mean(index_1980:index_2050, :);

dICEX_dt_1980_2050 = (icex_mean(index_2050, :) - icex_mean(index_1980, :)) / (2050 - 1980);
dAMOC_dt_1980_2050 = (amoc_mean(index_2050, :) - amoc_mean(index_1980, :)) / (2050 - 1980);

%가정
a = -1; 
a2 = 2.4006;
a_times_mean_AMOC_1980_2050 = a * amoc_mean_1980_2050;
a_times_dICEX_dt_1980_2050 = a2 * dICEX_dt_1980_2050;

figure;
subplot(2, 2, 1);
scatter(dAMOC_dt_1980_2050, a_times_mean_AMOC_1980_2050, 'filled');
title('dAMOC/dt (1980-2050) and a * mean(AMOC) (1980-2050)');
xlabel('dAMOC/dt [Sv/year]');
ylabel('a * mean(AMOC) [Sv]');
hold on;
grid on;
coefficients_amoc = polyfit(dAMOC_dt_1980_2050, a_times_mean_AMOC_1980_2050, 1);
x_fit_amoc = linspace(min(dAMOC_dt_1980_2050), max(dAMOC_dt_1980_2050), 100);
y_fit_amoc = polyval(coefficients_amoc, x_fit_amoc);
plot(x_fit_amoc, y_fit_amoc, 'r-', 'LineWidth', 2);
correlation_coefficient = corrcoef(dAMOC_dt_1980_2050, a_times_mean_AMOC_1980_2050);
disp(['Correlation Coefficient: ', num2str(correlation_coefficient(1, 2))]);

%% dICEX/dt 
subplot(2, 2, 2);
scatter(dICEX_dt_1980_2050, a_times_mean_AMOC_1980_2050, 'filled');
title('dICEX/dt (1980-2050) and a * mean(AMOC) (1980-2050)');
xlabel('dICEX/dt [Sv/year]');
ylabel('a * mean(AMOC) [Sv]');
hold on;
grid on;
coefficients_icex = polyfit(dICEX_dt_1980_2050, a_times_mean_AMOC_1980_2050, 1);
x_fit_icex = linspace(min(dICEX_dt_1980_2050), max(dICEX_dt_1980_2050), 100);
y_fit_icex = polyval(coefficients_icex, x_fit_icex);
plot(x_fit_icex, y_fit_icex, 'r-', 'LineWidth', 2);
correlation_coefficient = corrcoef(dICEX_dt_1980_2050, a_times_mean_AMOC_1980_2050);
disp(['Correlation Coefficient: ', num2str(correlation_coefficient(1, 2))]);

%% dICEX/dt 
subplot(2, 2, 4);
scatter(dAMOC_dt_1980_2050, dICEX_dt_1980_2050, 'filled');
title('dICEX/dt (1980-2050) and a * dAMOC/dt (1980-2050)');
xlabel('dICEX/dt [Sv/year]');
ylabel('a * mean(AMOC) [Sv]');
hold on;
grid on;
coefficients = polyfit(dAMOC_dt_1980_2050, dICEX_dt_1980_2050, 1);
x_fit = linspace(min(dAMOC_dt_1980_2050), max(dAMOC_dt_1980_2050), 100);
y_fit = polyval(coefficients, x_fit);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
correlation_coefficient = corrcoef(dICEX_dt_1980_2050, dAMOC_dt_1980_2050);
disp(['Correlation Coefficient: ', num2str(correlation_coefficient(1, 2))]);


%{
amoc_strength_1980_2020 = mean(amoc_mean(index_1980:index_2020, :), 1);
amoc_decline_rate_2020_2060 = (amoc_ensemble_mean(index_2060) - amoc_ensemble_mean(index_2020)) / (2060 - 2020) * 40;

figure;

scatter(amoc_strength_1980_2020, amoc_decline_rate_2020_2060, 'filled');
title('Correlation between AMOC Strength (1980-2020) and Decline Rate (2020-2060)');
xlabel('AMOC Strength (1980-2020) [Sv]');
ylabel('AMOC Decline Rate (2020-2060) [Sv/year]');
grid on;
%}





