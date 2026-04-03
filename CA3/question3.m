%% Question 3: Analyzing a Sixth-Order Digital Elliptic Lowpass IIR Filter
% command to use: ellip
% this time, SB ripple is 30 dB less than PB. 
% so stopband attenuation 30 dB below passband level

clear; close all; clc;

N  = 6;
Wn = 0.33;     
Rp = 0.5;     
Rs = 30;    

[b,a] = ellip(N, Rp, Rs, Wn, 'low');

%% Frequency response

nfft = 2048;
[H,w] = freqz(b,a,nfft);

mag = abs(H);
ph  = unwrap(angle(H));

%% Pole-zero locations

z = roots(b);
p = roots(a);

%% Impulse response (first 20 samples)

n = 0:19;
h = impz(b,a,20);

%% Plots

figure('Name','6th-Order Elliptic Lowpass IIR','Color','w');

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

disp('First 20 samples of h[n]:');
disp(table(n(:), h(:), 'VariableNames', {'n','h'}));