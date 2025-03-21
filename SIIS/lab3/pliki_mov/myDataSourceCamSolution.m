classdef myDataSourceCamSolution < handle
    % Klasa realizująca odczyt danych z z kamery
    %
    % WERSJA: 17.09.2020, R2020a
    % Przykład użycia (użyj tego kodu do testów poprawności działania klasy): 
    %{
         parametryImportu=[];
         parametryImportu.nr     = 1; 
         vid1    = myDataSourceCamSolution(parametryImportu);
         IM      = vid1.pobierzDane;
         vidFPS  = vid1.vidFPS;
         nFrames = vid1.nFrames;
         imSize  = vid1.imSize;
         
         clear vid1
    %}
    %
    
    % Własności (dane, stan) dostępne do odczytu
    properties  (SetAccess = private)
        vidFPS              % FPS strumienia video (w tym przypadku = inf)
        nFrames             % liczba ramek pliku video (w tym przypadku = inf)
        imSize              % rozmiar ramki obrazu
    end
    
    % Własności prywatne
    properties  (Access = private)
        vidObj              % obiekt kamery
    end    
    
    % Metody klasy
    methods
        function obj = myDataSourceCamSolution(parametryImportu)
            % Konstruktor klasy - tutaj odbywa się inicjalizacja
            % > parametryImportu    - struktura parametrów:       
            %   .nr                  - numer kamery
            %   .resolution          - opc. rozdzielczość akwizycji (wg AvailableResolutions)
            
            % -------------------------------------------------------
            % UZUPEŁNIJ_1 - tworzenie obiektu webcam
            obj.vidObj          = webcam(parametryImportu.nr);
            % -------------------------------------------------------
            
            % opc. ustawianie rozdzielczości akwizycji
            if isfield(parametryImportu,'resolution')
                try
                    disp('Obsługiwane rozdzielczości: ')
                    disp(obj.vidObj.AvailableResolutions)
                    obj.vidObj.Resolution = parametryImportu.resolution;
                catch ME
                    disp('Podana rozdzielczość nie jest obsługiwana przez kamerę')
                    disp('Obsługiwane rozdzielczości: ')
                    disp(obj.vidObj.AvailableResolutions)
                end
            end
            
            % dane strumienia video
            im1 = snapshot(obj.vidObj);
            obj.vidFPS          = inf; % obiekt webcam nie udostępnia tej informacji
            obj.nFrames         = inf; % obiekt webcam nie udostępnia tej informacji
            obj.imSize          = [size(im1,1) size(im1,2)];
            
            disp('---=== myDataSourceCamSolution ===---')
            disp('Dane źródła video:       ')
            disp(['> numer kamery    = ' num2str(parametryImportu.nr)])
            disp(['> liczba ramek    = ' num2str(obj.nFrames)])
            disp(['> FPS             = ' num2str(obj.vidFPS)])
            disp(['> rozdzielczość   = ' num2str(obj.imSize(1)) 'x' num2str(obj.imSize(2))])                        
        end
        
        function dataFrame = pobierzDane(obj)
            % Odczyt kolejnej ramki   
            % OUTPUTS:
            % > dataFrame       - obraz RGB [m*n*3]

            % -------------------------------------------------------
            % UZUPEŁNIJ_2 - pobranie ramki obrazu z webcam
            dataFrame = snapshot(obj.vidObj);            
            % -------------------------------------------------------
        end
        
        function delete(obj)
            % Usuwanie obiektu (zwolnienie zasobów kamery)
            clear obj.vidObj 
        end
    end
end
