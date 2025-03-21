clear all;close all;clc

%% (1) 
wzorzecNr = 1;                  % numer wzorca do badania
nrOfStrongest = 100;            % max. ilosc najsilniejszych cech do wyboru
visON = 1;
% pobranie danych wzorca
load xd.mat
objImage        = modelData(wzorzecNr).objImage;
objValidPoints  = modelData(wzorzecNr).objValidPoints;
objFeatures     = modelData(wzorzecNr).objFeatures;

% wczytanie obarazu testowego
RGB = imread('wszystkie_1.jpg');

% detekcja i ekstrakcja cech charakterystycznych 
sceneImage = rgb2gray(RGB); 

% detekcja cech, wybór N najsilniejszych, ekstrakcja wektorów cech
scenePoints = detectSURFFeatures(sceneImage);
scenePoints = selectStrongest(scenePoints, nrOfStrongest);
[sceneFeatures, sceneValidPoints] = extractFeatures(sceneImage, scenePoints);
    
% dopasowanie cech między wzorcem a aktualnym obrazem
featurePairs        = matchFeatures(objFeatures, sceneFeatures,'unique',true);
matchedObjPoints    = objValidPoints(featurePairs(:, 1), :);
matchedScenePoints  = sceneValidPoints(featurePairs(:, 2), :);
    
% wizualizacja dopasowania cech
if visON==1
    figure;
    showMatchedFeatures(objImage, sceneImage, matchedObjPoints, ...        
        matchedScenePoints, 'montage');
    title('dopasowanie przed usuwanie outliers')
end

%% (2)
% Usunięcie "outliers" poprzez estymację transformacji geometrycznej i RANSAC
% <uzupelnij>
metric1 = length(matchedObjPoints) / length(objValidPoints);
[tform, inlierObjPoints, inlierScenePoints] = ...
estimateGeometricTransform(matchedObjPoints, matchedScenePoints,...
'affine');

figure;
showMatchedFeatures(objImage, sceneImage, inlierObjPoints, ...
    inlierScenePoints, 'montage');
title('dopasowanie po RANSAC');

%% (3) Wizualizacja (użycie parametrów transformacji)
pattern_name = "magneb6_wzorzec.jpg";
pattern = rgb2gray(imread(pattern_name));
objPolygon = [0 0; 2210 0; 2210 1462 ; 0 1462; 0 0];
    
% sprawdzenie prostokąta
figure;
imshow(objImage);
hold on
line(objPolygon(:, 1), objPolygon(:, 2), 'Color', 'r');

% transformacja współrzędnych i wizualizacja rezutlatu
% <uzupelnij>
newObjPolygon = transformPointsForward(tform, objPolygon); 
figure;
imshow(sceneImage);
hold on;
line(newObjPolygon(:, 1), newObjPolygon(:, 2), 'Color', 'y');
title('Zlokalizowany obiekt');

