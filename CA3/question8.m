%% Question 8: Varying the Passband Edge (firpm), fp = 0.27 and 0.33
clear; close all; clc;

%% Specs
N   = 29;
ord = N-1;
ws  = 0.36;                
fps = [0.27 0.33];         
Nfft = 8192;

for k = 1:numel(fps)
    fp = fps(k);

    %% Design (equal weighting in passband and stopband)
    h = firpm(ord, [0 fp ws 1], [1 1 0 0]);

    %% Frequency response
    [H,w] = freqz(h, 1, Nfft);
    mag = abs(H);
    wn  = w/pi;

    %% Ripple computations (NOT dB)
    pb = (wn <= fp);
    sb = (wn >= ws);

    delta_p1 = max(mag(pb));
    delta_p2 = min(mag(pb));
    delta_p  = max(abs(mag(pb) - 1));
    delta_s  = max(mag(sb));

    fprintf('\nfp = %.2f\n', fp);
    fprintf('delta_p1 = %.8g\n', delta_p1);
    fprintf('delta_p2 = %.8g\n', delta_p2);
    fprintf('delta_p  = %.8g\n', delta_p);
    fprintf('delta_s  = %.8g\n', delta_s);

    %% Impulse response plot
    n = 0:ord;
    figure('Color','w','Name',sprintf('Impulse Response (fp=%.2f)',fp));
    stem(n, h, 'filled'); grid on;
    xlabel('n'); ylabel('h[n]');
    title(sprintf('firpm LPF, N=%d, \\omega_p=%.2f\\pi, \\omega_s=%.2f\\pi', N, fp, ws));

    %% Magnitude response plot
    figure('Color','w','Name',sprintf('Magnitude Response (fp=%.2f)',fp));
    plot(wn, mag); grid on; xlim([0 1]);
    xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
    title(sprintf('Magnitude Response (Linear), \\omega_p=%.2f\\pi, \\omega_s=%.2f\\pi', fp, ws));

    %% Optional bounds overlay (helps when circling alternation points)
    figure('Color','w','Name',sprintf('Magnitude w/ Bounds (fp=%.2f)',fp));
    plot(wn, mag); grid on; xlim([0 1]); hold on;
    xline(fp, ':'); xline(ws, ':');
    yline(1 + delta_p, '--');
    yline(1 - delta_p, '--');
    yline(delta_s, '--');
    xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
    title(sprintf('Bounds (Linear), fp=%.2f', fp));
    legend('|H|','\omega_p','\omega_s','1+\delta_p','1-\delta_p','\delta_s','Location','best');
end