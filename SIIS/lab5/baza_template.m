%% (2) Tworzenie bazy wzorców
nrOfStrongest = 50; % ilosc najsilniejszych cech do wyboru

% <uzupe³nij>
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
    % (wskazówka - u¿yj funkcji: imread, fullfile, rgb2gray)
    % <uzupe³nij>
    imshow(objImage);
    % detekcja cech SURF i wybór N najsilniejszych
    % (wskazówka - u¿yj funkcji: 
    objPoints = detectSURFFeatures(objImage);
    objPoints = selectStrongest(objPoints,nrOfStrongest);
    % <uzupe³nij>
    hold on
    plot(objPoints);
    % ekstrakcja wektora cech
    [objFeatures, objValidPoints] = extractFeatures(objImage,objPoints);    
    % <uzupe³nij>
    
    % uzupelnianie zmiennej bazy danych
    modelData(i).objImage=objImage;
    modelData(i).objValidPoints=objValidPoints;
    modelData(i).objFeatures=objFeatures;
end
% zapis bazy do pliku MAT: save nazwapliku zmienna1 zmienna2 
save("xd.mat","modelData");
% <uzupe³nij>
