Amoc = load("AMOC_1993_2019.txt");
Ice = load("ice_extent_1979_2022.txt");

nan_999 = find(Ice==-9999); Ice(nan_999) = NaN;
clearvars nan_999

amoc_mean = zeros(1, length(Amoc)); 
ice_mean = zeros(1, length(Ice));   

year_amoc = (1993:2019);
year_ice = (1979:2022);

for i = 1 : length(Amoc)
    amoc_mean(i) = mean(Amoc(i,:)); 
end

for i = 1 : length(Ice)
    ice_mean(i) = tsnanmean(Ice(i,:));  
end

amoc_common = amoc_mean;
ice_common = ice_mean(15:41);

%% plot
figure;
plot(year_amoc, amoc_mean,LineWidth=2); hold on;
plot(year_ice, ice_mean,LineWidth=2);
legend('amoc_mean','ice_mean')

%% 회귀분석
mdl = fitlm(amoc_common, ice_common);
fprintf('Linear Regression Coefficients:\n');
disp(mdl.Coefficients.Estimate);

X = amoc_common(:);  
Y = ice_common(:);   

mdl = fitlm(X, Y);

predicted_ice_mean = predict(mdl, X);
figure;
scatter(amoc_common, ice_common, 'filled');
hold on;
plot(amoc_common, predicted_ice_mean, 'LineWidth', 2);
xlabel('AMOC Mean');
ylabel('Ice Mean');
legend('Observed', 'Predicted');
title('Linear Regression Prediction of Ice Mean from AMOC Mean');

%%피어슨 상관계수 
load("Amoc.mat")
load("ice.mat")

correlation_matrix = corrcoef(amoc_common, ice_common);
correlation_coefficient = correlation_matrix(1, 2);
fprintf('AMOC와 북극 해빙면적 간의 피어슨 상관계수 (공통 기간): %.4f\n', correlation_coefficient);


%계절별 비교
%미디엄 이미션 시나리오를 보기
%x축을 최근 30년동안의 강도 y축을 미래의 강도 변화
%-> 모형을 통한 현재를 통해 미래를 예측할 수 있음
%모형 데이터
%amoc의 장주기성을 확인 -> fft 주기성 분석
%amoc의 경우 계절성이 떨어짐
%frequency 를 period로 변화해야함/ 잘봐야됨 
%주기가 통계적으로 유의미한가에 대한 검증
%amoc 증분률 확인



