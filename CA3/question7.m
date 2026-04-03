%% Question 7: Optimal Lowpass Filter
clear; close all; clc;

%% Specs
N  = 29;              % length
ord = N-1;            % firpm order
wp = 0.30;            % passband edge 
ws = 0.36;            % stopband edge

%% Design (equal weighting in passband and stopband)
h = firpm(ord, [0 wp ws 1], [1 1 0 0]);   % freq grid normalized to [0,1] == [0,pi]

%% Frequency response
Nfft = 8192;
[H,w] = freqz(h, 1, Nfft);              
mag = abs(H);
wn  = w/pi;                               

%% Plots for impulse response
n = 0:ord;
figure('Name','Impulse Response (firpm)','Color','w');
stem(n, h, 'filled'); grid on;
xlabel('n'); ylabel('h[n]');
title(sprintf('Optimal LPF (firpm), N=%d, \\omega_p=%.2f\\pi, \\omega_s=%.2f\\pi', N, wp, ws));

%% Plots for magnitude response
figure('Name','Magnitude Response (firpm)','Color','w');
plot(wn, mag); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Magnitude Response (Linear Scale)');

%% Ripple limits 
pb = (wn <= wp);          % passband region
sb = (wn >= ws);          % stopband region

delta_p1 = max(mag(pb));  % max magnitude in pb
delta_p2 = min(mag(pb));  % min magnitude in pb

%% Requested deltas:
% 1 - δp <= |H| <= 1 + δp in passband  => δp = max(|H-1|) over passband
delta_p = max(abs(mag(pb) - 1));

%% δs >= |H| in stopband => δs = max(|H|) over stopband
delta_s = max(mag(sb));

fprintf('\nExercise 7 (firpm) Ripple Results\n');
fprintf('Passband max |H| (delta_p1) = %.8g\n', delta_p1);
fprintf('Passband min |H| (delta_p2) = %.8g\n', delta_p2);
fprintf('delta_p (max |H-1| in passband) = %.8g\n', delta_p);
fprintf('delta_s (max |H| in stopband)   = %.8g\n', delta_s);

figure('Name','Magnitude Response w/ Bounds','Color','w');
plot(wn, mag); grid on; xlim([0 1]);
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Magnitude Response with Passband/Stopband Bounds (Linear)');
hold on;
yline(1 + delta_p, '--');
yline(1 - delta_p, '--');
yline(delta_s,     '--');
xline(wp, ':'); xline(ws, ':');
legend('|H|','1+\delta_p','1-\delta_p','\delta_s','\omega_p','\omega_s','Location','best');