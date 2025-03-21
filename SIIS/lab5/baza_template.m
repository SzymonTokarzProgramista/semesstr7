%% (2) Tworzenie bazy wzorc�w
nrOfStrongest = 50; % ilosc najsilniejszych cech do wyboru

% <uzupe�nij>
 fileNames = {'magneB6_wzorzec.jpg', 'NoSpa_wzorzec.jpg', 'chlorchinaldin_wzorzec.jpg', 'vitaminumB_wzorzec.jpg'}; 
        
modelData=struct('objImage', [],...
                 'objValidPoints', [],...
                 'objFeatures', []);
             
for i=1:length(fileNames)
    figure
    % wczytanie pliku wzorca i konwersja do grayscale
    x=char(fileNames(i));
    I=imread(x);
    objImage=rgb2gray(I);
    % (wskaz�wka - u�yj funkcji: imread, fullfile, rgb2gray)
    % <uzupe�nij>
    imshow(objImage);
    % detekcja cech SURF i wyb�r N najsilniejszych
    % (wskaz�wka - u�yj funkcji: 
    objPoints = detectSURFFeatures(objImage);
    objPoints = selectStrongest(objPoints,nrOfStrongest);
    % <uzupe�nij>
    hold on
    plot(objPoints);
    % ekstrakcja wektora cech
    [objFeatures, objValidPoints] = extractFeatures(objImage,objPoints);    
    % <uzupe�nij>
    
    % uzupelnianie zmiennej bazy danych
    modelData(i).objImage=objImage;
    modelData(i).objValidPoints=objValidPoints;
    modelData(i).objFeatures=objFeatures;
end
% zapis bazy do pliku MAT: save nazwapliku zmienna1 zmienna2 
save("xd.mat","modelData");
% <uzupe�nij>
