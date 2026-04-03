%% Frequency Modulated Signals Question 1)
% 1. Generate a DT linear FM chirp signal sampled at 5 MHz for 200 us
% using provided equation
% 2. Convert the CT signal to DT using t = n/fs (fs = 5 * 10^6)
% 3. Find STFT of signal using 256-point FFT, 256-sample tri window, 
% 255-sample overlap 
% 4. Plot frequency vs time (visualize chirp's frequency over time)

fs = 5e6;
mu = 4e9;
T = 200e-6;

N = fs*T;                    
n = 0:N-1;
t = n/fs;

x = cos(2*pi*mu*t.^2);

figure;
spectrogram(x, triang(256), 255, 256, fs, 'yaxis');
title('Spectrogram of Linear FM Chirp');