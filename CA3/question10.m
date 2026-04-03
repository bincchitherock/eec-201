%% Exercise 10: Optimal vs. Window FIR 
clear; close all; clc;

% Given from Exercise 6 (Kaiser beta=6)
wp = 0.189575;       
ws = 0.466675;       

% Specs
N    = 29;
ord  = N-1;
wc   = 0.33*pi;        % same ideal cutoff used in ex. 6 
beta = 6;
Nfft = 8192;

%% Window-method filter: Kaiser beta=6 
n  = 0:ord;
M  = ord/2;
hd = sin(wc*(n - M)) ./ (pi*(n - M));
hd(n==M) = wc/pi;

wK = kaiser(N, beta).';
h_win = (hd .* wK).';          % column

%% Optimal equiripple filter with same wp, ws
h_opt = firpm(ord, [0 wp ws 1], [1 1 0 0]);

%% Frequency responses
[Hwin, w] = freqz(h_win, 1, Nfft);
[Hopt, ~] = freqz(h_opt, 1, Nfft);
magW = abs(Hwin);
magO = abs(Hopt);
wn   = w/pi;

%% Compute deltas
pb = (wn <= wp);
sb = (wn >= ws);

delta_p_opt = max(abs(magO(pb) - 1));
delta_s_opt = max(magO(sb));

delta_p_win = max(abs(magW(pb) - 1));
delta_s_win = max(magW(sb));

fprintf('\nOptimal (firpm): delta_p = %.8g, delta_s = %.8g\n', delta_p_opt, delta_s_opt);
fprintf('Window (Kaiser beta=6): delta_p = %.8g, delta_s = %.8g\n', delta_p_win, delta_s_win);

%% Plot 1: zoom in on passband
figure('Color','w','Name','Passband Zoom');
plot(wn, magW, wn, magO); grid on;
xlim([0 wp]);
ylim([min([magW(pb); magO(pb)])-0.01, max([magW(pb); magO(pb)])+0.01]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Passband Zoom: Kaiser (\beta=6) vs Optimal (firpm)');
legend('Kaiser \beta=6 (window)','Optimal (firpm)','Location','best');

%% Plot 2: zoom in on stopband
figure('Color','w','Name','Stopband Zoom');
plot(wn, magW, wn, magO); grid on;
xlim([ws 1]);
ylim([0, max([magW(sb); magO(sb)])*1.1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Stopband Zoom: Kaiser (\beta=6) vs Optimal (firpm)');
legend('Kaiser \beta=6 (window)','Optimal (firpm)','Location','best');