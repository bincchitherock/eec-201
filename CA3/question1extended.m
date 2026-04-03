%% 
%  Toolbox-free Butterworth Lowpass IIR (6th order) + Analysis
%  (No butter, freqz, zplane, impz, etc.)
%  Spec from (1): N = 6, wc = 0.33*pi  -> Wn = 0.33 (normalized)

clear; close all; clc;

%% Filter parameters from the prompt:
N  = 6;                         % 6th-order
Wn = 0.33;                      % Normalized cutoff
wc = Wn*pi;                     % Converting Wn into a digital rad/sample cutoff.

%% Prewarping the cutoff for the bilinear transform ----
% I used T = 1, so the bilinear prewarp is:  Wc = 2*tan(wc/2).

Wc = 2*tan(wc/2);               % Analog cutoff that maps to wc after bilinear transform.

%% Computing the analog Butterworth poles:
% I placed the N Butterworth poles uniformly on a circle of radius Wc,
% and I used the standard angle formula that gives only left-half-plane poles.

p = zeros(N,1);               
for k = 0:N-1
    theta = pi*(2*k + 1 + N)/(2*N);  
    p(k+1) = Wc * exp(1j*theta);  
end

%% Mapping analog poles into digital poles (bilinear) 
% I used:  z = (2 + s)/(2 - s)  (I.e. Bilinear transform with T = 1).

pd = (2 + p)./(2 - p);          

%% Digital zeros 
% A Butterworth lowpass has no finite analog zeros, so after bilinear transform
% the "zeros at infinity" map to zeros at z = -1 (repeated N times).

zd = -ones(N,1);             

%% Setting the gain so DC gain is 1
% I enforced H(z=1) = 1 by solving:
% H(1) = k * prod(1 - z_i^-1) / prod(1 - p_i^-1)  = 1.

k = real( prod(1 - pd.^(-1)) / prod(1 - zd.^(-1)) ); 

%% Zeros/poles/gain into polynomial b,a:
b = k * poly(zd);               % Numerator polynomial from the zeros.
a = poly(pd);                   % Denominator polynomial from the poles.
b = real(b); a = real(a);       % Real coefficients (tiny imag parts are numerical noise).

%% Frequency response (no freqz):
nfft = 2048;                    % Chose how many frequency samples I want.
w = linspace(0, pi, nfft).';    % Built a grid from 0 to pi rad/sample.

H = H_of_ejw(b, a, w);          % Evaluated H(e^{jw}) directly from b,a.
mag = abs(H);                   % Magnitude response.
ph  = unwrap(angle(H));         % Computed the unwrapped phase response.

%% First 20 impulse samples (no impz) 
L = 20;                         % I only needed the first 20 values.
h = impulse_response(b, a, L);  % I generated the impulse response using the difference equation.
n = (0:L-1).';                  % I created the sample index vector.

%% Poles and zeros 
z = roots(b);               
p2 = roots(a);          

%% Plots

figure('Name','Toolbox-free Butterworth LPF (N=6, Wn=0.33)','Color','w');

subplot(2,2,1);
plot(w/pi, mag, 'LineWidth', 1); grid on;
xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|');
title('Magnitude Response');

subplot(2,2,2);
plot(w/pi, ph, 'LineWidth', 1); grid on;
xlabel('\omega/\pi'); ylabel('Phase (rad)');
title('Unwrapped Phase Response');

subplot(2,2,3);
pz_plot(z, p2);            
title('Pole-Zero Plot');

subplot(2,2,4);
stem(n, h, 'filled'); grid on;
xlabel('n'); ylabel('h[n]');
title('Impulse Response (first 20 samples)');

disp('First 20 samples of h[n] (n = 0..19):');
disp(table(n, h, 'VariableNames', {'n','h'}));

%% Local Functions
function H = H_of_ejw(b, a, w)
%   H(e^{jw}) = (sum_k b(k) e^{-jw(k-1)}) / (sum_k a(k) e^{-jw(k-1)})

    nb = length(b);                             % Numerator taps.
    na = length(a);                             % Denominator taps.

    Eb = exp(-1j*w*(0:nb-1));                   % Exponent matrix for the numerator.
    Ea = exp(-1j*w*(0:na-1));                   % Exponent matrix for the denominator.

    Num = Eb * b(:);                            % Numerator on the frequency grid.
    Den = Ea * a(:);                            % Denominator on the frequency grid.

    H = Num ./ Den;                             % Frequency response.
end

function h = impulse_response(b, a, L)
%   y[n] = sum_{k=0}^{Nb-1} b[k] x[n-k] - sum_{k=1}^{Na-1} a[k] y[n-k]
%   with x[0]=1 and x[n>0]=0.

    nb = length(b);                             % Numerator length.
    na = length(a);                             % Denominator length.

    x = zeros(L,1); x(1) = 1;                   % Delta[n] as the input.
    y = zeros(L,1);                             % Allocated space for the output.

    for n = 1:L                                 % Stepped through time from 0 to L-1.
        acc_num = 0;                            % Reset the feedforward accumulator.
        for k = 1:nb                            % Summed the feedforward terms.
            idx = n - (k-1);                    % Needed input index.
            if idx >= 1
                acc_num = acc_num + b(k)*x(idx);
            end
        end

        acc_den = 0;                            % Reset the feedback accumulator.
        for k = 2:na                            % Summed the feedback terms (skipping a(1)).
            idx = n - (k-1);                    % Needed past-output index.
            if idx >= 1
                acc_den = acc_den + a(k)*y(idx);
            end
        end

        y(n) = (acc_num - acc_den) / a(1);      
    end

    h = y;                                      % I returned y as the impulse response.
end

function pz_plot(z, p)
% I made a simple pole-zero plot without zplane.

    t = linspace(0, 2*pi, 400);                 % I parameterized the unit circle.
    plot(cos(t), sin(t), 'k--'); hold on;       % I drew the unit circle as a reference.
    grid on; axis equal;                        % I turned on grid and fixed aspect ratio.

    if ~isempty(z)
        plot(real(z), imag(z), 'bo', 'LineWidth', 1.5);  % I plotted zeros as circles.
    end
    if ~isempty(p)
        plot(real(p), imag(p), 'rx', 'LineWidth', 1.5);  % I plotted poles as x's.
    end

    xlabel('Real'); ylabel('Imag');             % I labeled the axes.
    legend('Unit circle','Zeros','Poles','Location','best'); % I added a legend.
    xlim([-1.5 1.5]); ylim([-1.5 1.5]);         % I set reasonable plot limits.
end