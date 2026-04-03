%% Exercise 11: Changing Filter Length 
% (firpm) — N=39 vs N=29 (from ex. 7)
clear; close all; clc;

%% Specs (shoudl be same band edges as exercise 7)
wp = 0.30;          
ws = 0.36;       
Nfft = 8192;

%% Optimal 29-point filter 
N29   = 29;
ord29 = N29 - 1;
h29   = firpm(ord29, [0 wp ws 1], [1 1 0 0]);

[H29,w] = freqz(h29, 1, Nfft);
mag29   = abs(H29);
wn      = w/pi;

%% Optimal 39-point filter
N39   = 39;
ord39 = N39 - 1;
h39   = firpm(ord39, [0 wp ws 1], [1 1 0 0]);

[H39,~] = freqz(h39, 1, Nfft);
mag39   = abs(H39);

%% Ripples for the 39-point filter
pb = (wn <= wp);
sb = (wn >= ws);

delta_p_39 = max(abs(mag39(pb) - 1));
delta_s_39 = max(mag39(sb));

fprintf('\n39-point optimal (firpm):\n');
fprintf('delta_p = %.8g\n', delta_p_39);
fprintf('delta_s = %.8g\n', delta_s_39);

%% Both mag responses plot
figure('Color','w','Name','Magnitude Response: N=29 vs N=39');
plot(wn, mag29, wn, mag39); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Optimal LPF Magnitude Responses (Linear): N=29 vs N=39');
legend('N=29 (Ex. 7)','N=39 (Ex. 11)','Location','best');

%% Zoomed plots (so i can visually compare ripple reduction)
figure('Color','w','Name','Passband Zoom: N=29 vs N=39');
plot(wn, mag29, wn, mag39); grid on;
xlim([0 wp]);
ylim([min([mag29(pb); mag39(pb)])-0.01, max([mag29(pb); mag39(pb)])+0.01]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Passband Zoom (Linear): N=29 vs N=39');
legend('N=29','N=39','Location','best');

figure('Color','w','Name','Stopband Zoom: N=29 vs N=39');
plot(wn, mag29, wn, mag39); grid on;
xlim([ws 1]);
ylim([0, max([mag29(sb); mag39(sb)])*1.1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Stopband Zoom (Linear): N=29 vs N=39');
legend('N=29','N=39','Location','best');