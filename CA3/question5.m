%% Question 5: Rectangular & Hamming
clear; close all; clc;

%% Specs
N  = 29;                 
M  = (N-1)/2;           
wc = 0.33*pi;           

%% Ideal LPF impulse response (shifted sinc)
n  = 0:N-1;
hd = sin(wc*(n - M)) ./ (pi*(n - M));  
hd(n==M) = wc/pi;               

%% Windows
w_rect = ones(N,1);
w_hamm = hamming(N);

%% FIR coefficients
h_rect = hd(:).*w_rect;
h_hamm = hd(:).*w_hamm;

%% Frequency response 
Nfft = 8192;
[Hrect,w] = freqz(h_rect,1,Nfft);
[Hhamm,~] = freqz(h_hamm,1,Nfft);

%% Plots for the impulse response
figure('Name','Impulse Responses','Color','w');
subplot(2,1,1);
stem(n, h_rect, 'filled'); grid on;
xlabel('n'); ylabel('h_{rect}[n]');
title(sprintf('29-point LPF (Rectangular Window), \\omega_c = %.2f\\pi', wc/pi));

subplot(2,1,2);
stem(n, h_hamm, 'filled'); grid on;
xlabel('n'); ylabel('h_{hamm}[n]');
title(sprintf('29-point LPF (Hamming Window), \\omega_c = %.2f\\pi', wc/pi));

%% Plots for the Magnitude reponses
figure('Name','Magnitude Responses','Color','w');
subplot(2,1,1);
plot(w/pi, abs(Hrect)); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H_{rect}(e^{j\omega})|');
title('Magnitude Response (Rectangular Window)');

subplot(2,1,2);
plot(w/pi, abs(Hhamm)); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H_{hamm}(e^{j\omega})|');
title('Magnitude Response (Hamming Window)');

%% For visual understanding: overlay
figure('Name','Magnitude Response Overlay','Color','w');
plot(w/pi, abs(Hrect)); hold on;
plot(w/pi, abs(Hhamm));
grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
legend('Rectangular','Hamming','Location','best');
title('Magnitude Response Overlay (Linear Scale)');