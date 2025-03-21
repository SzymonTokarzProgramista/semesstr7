%% (1-2) Szablon do przeprowadzania test�w (wczytanie obrazow w trybie wsadowym, generacja nazw plikow...)
close all;clc
% parametry testu 
baseFileName = 'obraz_';        % bazowa nazwa plik�w testowych
fileExtension = '.jpg';         % rozszerzenie plik�w testowych
fileNr = 1:17;                  % numery plik�w testowych

wzorzecNr = 4;                  % numer wzorca do badania
visON     = 0;                  % 1- w��czenie wizualizacji, 0-wy��czenie

% pobranie danych wzorca
load xd.mat
objImage = modelData(wzorzecNr).objImage;
objValidPoints = modelData(wzorzecNr).objValidPoints;
objFeatures = modelData(wzorzecNr).objFeatures;
% (wskaz�wka: zwr�� uwag� na fakt, �e objFeatures jest tablic�, a
% objValidPoints - struktur�)

% p�tla � wczytywanie kolejnych obraz�w i wyznaczenie dopasowania
metric1=zeros(length(fileNr),1); % wektor rezultat�w (preallokacja)
for i=1:length(fileNr)     
    % nazwa wczytywanego pliku
    % <uzupelnij>
    nazwa1 = strcat(baseFileName,num2str(fileNr(i)),fileExtension);
    %          <filename> sk�ada si� z: baseFileName, num2str(fileNr(i)), fileExtension

    disp(nazwa1);
    RGB=imread(nazwa1);
    sceneImage = rgb2gray(RGB); 
        
    % detekcja cech, wyb�r N najsilniejszych, ekstrakcja wektor�w cech
    % <uzupe�nij>
    scenePoints = detectSURFFeatures(sceneImage);
    scenePoints = selectStrongest(scenePoints,100);
    [sceneFeatures, sceneValidPoints] = extractFeatures(sceneImage,scenePoints);
   

    % dopasowanie cech mi�dzy wzorcem a aktualnym obrazem
    featurePairs = matchFeatures(objFeatures, sceneFeatures,'unique',true);
    matchedObjPoints = objValidPoints(featurePairs(:, 1), :);
    matchedScenePoints = sceneValidPoints(featurePairs(:, 2), :);
    
    % wizualizacja dopasowania cech
    if visON==1
        figure;
        showMatchedFeatures(objImage, sceneImage, matchedObjPoints, ...        
            matchedScenePoints, 'montage');
    end
    
    % wyznaczenie miary dopasowania I zapami�tanie w zmiennej
    metric1(i) = length(matchedObjPoints) / length(objValidPoints);
end
% Wy�wietl na osobnym wykresie miar� dopasowania "metric1"
% <uzupe�nij>
figure
plot(metric1);

%% (3) Uzupe�nij kod (osobna sekcja) o prosty algorytm klasyfikacji obraz�w testowych
%close all;
groundTruthTab={[1 2 3 4];...
[10 11 12 13];...
[5 6 7 8 9];...
[14 15 16 17];...
};
% przyj�ty procentowy pr�g rozpoznania
thresholdTab = [0.1 0.035 0.1 0.065];
threshold1 = thresholdTab(wzorzecNr);
% dla wybranego wzorca, znalezienie obraz�w dla kt�rych miara dopasowania
% jest > przyj�tego progu
groundTruth = groundTruthTab{wzorzecNr};
detected = find(metric1>threshold1);
% Bledy I i II rodzaju
czesc_wspolna = intersect(groundTruth, detected);
nad_wykrycia = setdiff(detected, czesc_wspolna);
alpha = length(setdiff(groundTruth, detected)) / length(groundTruth);
beta = length(nad_wykrycia) / length(groundTruth);
% wizualizacja rezultat�w i poprawnej klasyfikacji
figure('Position', [0 0 600 400]);
plot(fileNr, metric1, '-b', 'Marker', '.');
hold on; grid on;
plot(groundTruth, metric1(groundTruth), 'r', 'Marker', 'x', 'LineStyle', 'none');
plot(detected, metric1(detected), 'g', 'Marker', 'o', 'LineStyle', 'none');
plot([0 length(fileNr)], [threshold1 threshold1], '--k');
legend(["miara dopasowania", "popawna klasyfikacja", "rezultaty klasyfikacji", "poziom przyjetego progu"],...
'location', 'NorthWest')
title(strcat("Wzorzec nr ",...
num2str(wzorzecNr),...
", \alpha = ", num2str(alpha),...
", (1-\beta) = ", num2str(1 - beta)));
ylabel("Miara dopasowania");
xlabel("Numer obrazu");


