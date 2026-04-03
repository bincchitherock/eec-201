%% Frequency Modulated Signals Question 3) 
% 1. Change the chirp rate to 1 * 10^10 and predict how the spectogram
% ridge will change 
% 2. Generate a new DT chirp signal using this new chirp rate
% 3. Find the spectogram of this new signal 
% 4. Compare this spectogram to the one from part (1) and explain
% how the larger chirp rate changes the slope and freq of ridge. 

fs = 5e6;                  
mu2 = 1e10;                
T = 200e-6;             

N = fs * T;               
n = 0:N-1;           
t = n / fs;              

x2 = cos(2*pi*mu2*t.^2);  

figure;
spectrogram(x2, triang(256), 255, 256, fs, 'yaxis');
title('Spectrogram of x_2[n] for \mu = 1.0 \times 10^{10}');

