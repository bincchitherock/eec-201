%% Question 1: Analyzing a Sixth-Order Digital Butterworth Lowpass Filter
% using 'butter' to design a 6th-order LP IIR filter with wc = 0.33pi
% Wn = 0.33

clear; close all; clc;

N  = 6;
Wn = 0.33;                
[b,a] = butter(N, Wn, 'low');


%% (a) Calculating the frequency response
% magnitude + phase 

nfft = 2048;
[H,w] = freqz(b,a,nfft);   

mag = abs(H);
mag_db = 20*log10(max(mag,1e-12));
ph  = unwrap(angle(H));

%% (b) Pole-zero plot
% b = numerator 
% a = denominator 

z = roots(b);
p = roots(a);

%% (c) Impulse response (first 20 values) 
% 0 ~ 19 = 20

n  = 0:19;
h  = impz(b,a,20);


%% (d) Plotting Everything

figure('Name','6th-Order Butterworth Lowpass IIR','Color','w');

subplot(2,2,1);
plot(w/pi, mag); grid on;
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Magnitude Response');

subplot(2,2,2);
plot(w/pi, ph); grid on;
xlabel('\omega/\pi'); ylabel('Unwrapped Phase (rad)');
title('Phase Response');

subplot(2,2,3);
zplane(z,p); grid on;
title('Pole-Zero Plot');

subplot(2,2,4);
stem(n, h, 'filled'); grid on;
xlabel('n'); ylabel('h[n]');
title('Impulse Response of the first 20 samples');

%% Printing the first 20 impulse samples
disp('First 20 samples of h[n]:');
disp(table(n(:), h(:), 'VariableNames', {'n','h'}));