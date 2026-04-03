%% Question 9: Varying the Transition Bandwidth
clear; close all; clc;

%% Specs
N   = 29;
ord = N-1;
fc  = 0.33;                 
tbws = [0.15 0.01];         
Nfft = 8192;

for k = 1:numel(tbws)
    tbw = tbws(k);
    fp  = fc - tbw;         % passband edge
    fs  = fc + tbw;         % stopband edge

    %% Design
    h = firpm(ord, [0 fp fs 1], [1 1 0 0]);

    %% Frequency response
    [H,w] = freqz(h, 1, Nfft);
    mag = abs(H);
    wn  = w/pi;

    %% Ripples 
    pb = (wn <= fp);
    sb = (wn >= fs);

    delta_p = max(abs(mag(pb) - 1));
    delta_s = max(mag(sb));

    fprintf('\ntbw = %.2f  (fp = %.2f, fs = %.2f)\n', tbw, fp, fs);
    fprintf('delta_p = %.8g\n', delta_p);
    fprintf('delta_s = %.8g\n', delta_s);

    %% Magnitude response plot (linear)
    figure('Color','w','Name',sprintf('Magnitude Response (tbw=%.2f)',tbw));
    plot(wn, mag); grid on; xlim([0 1]);
    xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
    title(sprintf('firpm Magnitude (Linear), fp=%.2f, fs=%.2f', fp, fs));

    %% Bounds overlay
    figure('Color','w','Name',sprintf('Magnitude w/ Bounds (tbw=%.2f)',tbw));
    plot(wn, mag); grid on; xlim([0 1]); hold on;
    xline(fp, ':'); xline(fs, ':');
    yline(1 + delta_p, '--');
    yline(1 - delta_p, '--');
    yline(delta_s, '--');
    xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
    title(sprintf('Bounds (Linear), tbw=%.2f', tbw));
    legend('|H|','f_p','f_s','1+\delta_p','1-\delta_p','\delta_s','Location','best');
end