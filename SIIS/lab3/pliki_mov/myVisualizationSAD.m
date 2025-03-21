classdef myVisualizationSAD < handle
    % Klasa realizująca wizualizację danych dla ćwiczenia SAD
    % WERSJA: 12.10.2020, R2020a
    % Przykład użycia: 
    %{
       A                = imread('ngc6543a.jpg');
       vis1             = myVisualizationSAD;
       dane             = [];       
       dane.outVidData.RGB  = A;
       dane.outVidData.DIFFIM = rgb2gray(A);
       dane.outVidData.sum = 12;
       dane.iter        = 10;
       vis1.wyswietlDane(dane)
    
       delete(vis1)  % używać tego zamiast "clear vis1"    
    %}
    %
    
    % Własności dostępne do odczytu
    properties  (SetAccess = private)
        stopCond                 % flaga zakończenia przetwarzania (ustawiana w GUI na 0 co oznacza zakończenie działania aplikacji)
        pauseCond                % flaga włączenia pauzy przetwarzania (ustawiana w GUI na 1 oznacza pauzę, na 0 - wznowienie przetwarzania)      
    end
    
    % Własności prywatne
    properties  (Access = private)
        videoPlayer              % uchwyt do okna wykresu
    end

    % Metody klasy
    methods
        function obj = myVisualizationSAD()
            % Konstruktor klasy - tutaj odbywa się inicjalizacja
            % 
            disp('---=== myVisualizationSAD ===---')
            obj.videoPlayer  = figure;      % uchwyt do okna GUI
            guih             = [];            
            guih(1)          = uicontrol(obj.videoPlayer,'units','normalized','position',[0 0 0.2 0.05],...
                                    'string','stop','callback',@(src, event) handleButtons(obj, src, event));  
            guih(2)          = uicontrol(obj.videoPlayer,'units','normalized','position',[0.3 0 0.2 0.05],...
                                'string','pause','callback',@(src, event) handleButtons(obj, src, event));  
            obj.stopCond     = 1;           
            obj.pauseCond    = 0;           
        end
        
        function wyswietlDane(obj, data)
            % Wizualizacja danych "data" na wykresie   
            % INPUTS:
            % > data       - dane do wizualizacji (struktura)
            %   .outVidData.RGB     - obraz RGB do wyświetlenia
            %   .outVidData.DIFFIM  - obraz różnicowy do wyświetlenia
            %   .outVidData.motion  - rezultat detekcji ruchu
            %   .outVidData.sum     - wartość SAD
            %   .iter        - numer ramki
                 
            subplot(1,2,1);
            imshow(data.outVidData.RGB)       
            title(['Ramka nr ' num2str(data.iter)])
            subplot(1,2,2);
            imshow(data.outVidData.DIFFIM,[])
            title(['SAD = ' num2str(data.outVidData.sum)])
            if data.outVidData.motion==1
                xlabel('wykryto ruch')
            else
                xlabel('')
            end
            
        end
        
        function delete(obj)
            % Usuwanie obiektu
            close(obj.videoPlayer)
        end
    end
    methods (Access = private)
        function handleButtons(obj, src, event)
            % Metoda wewnętrzna - obsługa przycisków
            if strcmp(src.String,'stop')
                obj.stopCond = 0;
                %disp('nacisnieto stop')
            else % w przypadku rozbudowy o kolejne przyciski, tutaj porównać nazwę z "pause" i "continue"
                if obj.pauseCond==1                    
                    obj.pauseCond = 0;
                    src.String = 'pause';                    
                else
                    obj.pauseCond = 1;
                    src.String = 'continue';
                end                
            end            
        end
    end
end

