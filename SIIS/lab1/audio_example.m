%% Przykład akwizycji audio z mikrofonu
% 
% UWAGI:
% > na podstawie przykładu z dokumentacji: Real-Time Audio in MATLAB
% > więcej informacji w dokumentacji:
%   >> doc 'Audio I/O: Buffering, Latency, and Throughput'
% WERSJA: 17.09.2020, autor: Jaromir Przybylo (przybylo@agh.edu.pl), MATLAB R2020a
% 
clear all;close all;clc

%% Tworzenie obiektów do obsługi wejść i wyjść audio
frameLength = 1024;         % długość bufora audio w próbkach
fs          = 16000;        % częstotliwość próbkowania w Hz

% obiekt obsługujący wejście audio (mikrofon)
audioReader = audioDeviceReader('SampleRate',fs,...
    'SamplesPerFrame',frameLength);

% obiekt obsługujący wyjście audio (głośnik)
deviceWriter = audioDeviceWriter( ...
    'SampleRate',audioReader.SampleRate);

% obiekt wizualizacji sygnału
scope = dsp.TimeScope( ...
    'SampleRate',audioReader.SampleRate, ...
    'TimeSpan',2, ...
    'BufferLength',audioReader.SampleRate*2*2, ...
    'YLimits',[-1,1], ...
    'TimeSpanOverrunAction',"Scroll");

% obiekt przetwarzania sygnału
reverb = reverberator( ...
    'SampleRate',audioReader.SampleRate, ...
    'PreDelay',0.5, ...
    'WetDryMix',0.4);


%% Pętla akwizycji audio
disp('początek akwizycji audio')
czasAkwizycji = 25;          % [s]
tic
while toc < czasAkwizycji
    signal = audioReader();
    reverbSignal = reverb(signal);
    deviceWriter(reverbSignal);
    scope([signal,mean(reverbSignal,2)])
end
disp('koniec akwizycji audio')

% zwolnienie zasobów
release(audioReader)
release(deviceWriter)
release(reverb)
release(scope)

