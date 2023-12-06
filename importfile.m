function importfile(fileToRead1)
%IMPORTFILE(FILETOREAD1)
%  지정된 파일에서 데이터 가져오기
%  FILETOREAD1:  읽을 파일

%  MATLAB에서 08-Nov-2023 14:40:29에 자동 생성됨

% 파일 가져오기
rawData1 = importdata(fileToRead1);

% CSV 또는 JPEG 파일과 같은 일부 간단한 파일에 대해서는 IMPORTDATA가
% 단순 배열을 반환할 수 있습니다.  이런 경우에 해당된다면 구조체를 생성해
% 출력값이 가져오기 마법사의 출력값과 일치되게 하십시오.
[~,name] = fileparts(fileToRead1);
newData1.(matlab.lang.makeValidName(name)) = rawData1;

% 기본 작업 공간에 해당 필드로부터 새 변수를 생성합니다.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

