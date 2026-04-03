%% Exercise 12: Optimal FIR vs. Elliptic IIR Design
% Replacement: FIR frequency-sampling via fir2 (N=29 and N=39)

clear; close all; clc;

% Specs
wc   = 0.33;                 
f    = [0 wc wc 1];         
m    = [1 1 0 0];           
Nfft = 8192;

Ns = [29 39];

for k = 1:numel(Ns)
    N = Ns(k);
    ord = N-1;

    %% Design (fir2 frequency-sampling FIR)
    h = fir2(ord, f, m);

    %% Frequency response
    [H,w] = freqz(h, 1, Nfft);
    mag = abs(H);
    wn  = w/pi;

    %% Impulse response
    n = 0:ord;
    figure('Color','w','Name',sprintf('Impulse Response (fir2, N=%d)',N));
    stem(n, h, 'filled'); grid on;
    xlabel('n'); ylabel('h[n]');
    title(sprintf('fir2 Lowpass, N=%d, \\omega_c=%.2f\\pi', N, wc));

    %% Magnitude response (linear)
    figure('Color','w','Name',sprintf('Magnitude Response (fir2, N=%d)',N));
    plot(wn, mag); grid on; xlim([0 1]);
    xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
    title(sprintf('fir2 Magnitude (Linear), N=%d', N));

    % I need to use zoom on this plot to read off:
    %   delta_p1, delta_p2, omega_p, delta_s, omega_s
    % following the same definitions as Exercises 5/6.
end

