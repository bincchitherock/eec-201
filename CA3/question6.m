%% Question 6 Kaiser Window FIR Lowpass (beta = 4 and 6)
clear; close all; clc;

%% Specs
N  = 29;         
M  = (N-1)/2;      
wc = 0.33*pi;         

%% Ideal LPF impulse response (shifted sinc)
n  = 0:N-1;
hd = sin(wc*(n - M)) ./ (pi*(n - M));   
hd(n==M) = wc/pi;                     

%% Kaiser windows
beta1 = 4;
beta2 = 6;
w_k4  = kaiser(N, beta1);
w_k6  = kaiser(N, beta2);

%% FIR coefficients
h_k4 = hd(:).*w_k4;
h_k6 = hd(:).*w_k6;

%% Frequency response
Nfft = 8192;
[Hk4, w] = freqz(h_k4, 1, Nfft);
[Hk6, ~] = freqz(h_k6, 1, Nfft);

%% Impulse responses plots
figure('Name','Impulse Responses (Kaiser)','Color','w');
subplot(2,1,1);
stem(n, h_k4, 'filled'); grid on;
xlabel('n'); ylabel('h_{K,\beta=4}[n]');
title(sprintf('29-point LPF (Kaiser \\beta=%g), \\omega_c = %.2f\\pi', beta1, wc/pi));

subplot(2,1,2);
stem(n, h_k6, 'filled'); grid on;
xlabel('n'); ylabel('h_{K,\beta=6}[n]');
title(sprintf('29-point LPF (Kaiser \\beta=%g), \\omega_c = %.2f\\pi', beta2, wc/pi));

%% Magnitude Response plots
figure('Name','Magnitude Responses (Kaiser)','Color','w');
subplot(2,1,1);
plot(w/pi, abs(Hk4)); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H_{K,\beta=4}(e^{j\omega})|');
title('Magnitude Response (Kaiser \beta=4)');

subplot(2,1,2);
plot(w/pi, abs(Hk6)); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H_{K,\beta=6}(e^{j\omega})|');
title('Magnitude Response (Kaiser \beta=6)');

figure('Name','Magnitude Response Overlay (Kaiser)','Color','w');
plot(w/pi, abs(Hk4)); hold on;
plot(w/pi, abs(Hk6));
grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
legend('\beta = 4','\beta = 6','Location','best');
title('Magnitude Response Overlay (Linear Scale)');