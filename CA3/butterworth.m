%%  Toolbox-free Butterworth Lowpass IIR (6th order) + Analysis
%  (No butter, freqz, zplane, impz, etc.)
%  Spec from (1): N = 6, wc = 0.33*pi  -> Wn = 0.33 (normalized)

clear; close all; clc;

%% Filter parameters from the prompt
N  = 6;                    
Wn = 0.33;                 

wc = Wn*pi;                  

%% Prewarping the cutoff for the bilinear transform 
% I used T = 1, so the bilinear prewarp is:  Wc = 2*tan(wc/2).

Wc = 2*tan(wc/2);               % Analog cutoff that maps to wc after bilinear transform.

%% Analog Butterworth poles 
% I placed the N Butterworth poles uniformly on a circle of radius Wc,
% and I used the standard angle formula that gives only left-half-plane poles.

p = zeros(N,1);              
for k = 0:N-1
    theta = pi*(2*k + 1 + N)/(2*N);  
    p(k+1) = Wc * exp(1j*theta);    
end

%% Analog poles into digital poles (bilinear) ---
% I used:  z = (2 + s)/(2 - s)  
pd = (2 + p)./(2 - p);         

%% Digital zeros 
% A Butterworth lowpass has no finite analog zeros, so after bilinear transform
% the "zeros at infinity" map to zeros at z = -1 (repeated N times).

zd = -ones(N,1);                

%% DC gain = 1 
% I enforced H(z=1) = 1 by solving:
% H(1) = k * prod(1 - z_i^-1) / prod(1 - p_i^-1)  = 1.

k = real( prod(1 - pd.^(-1)) / prod(1 - zd.^(-1)) );  

%% Zeros/poles/gain into polynomial b,a 
b = k * poly(zd);             
a = poly(pd);               
b = real(b); a = real(a);    

%% Frequency response (with no freqz) ----------
nfft = 2048;                   
w = linspace(0, pi, nfft).';    

H = H_of_ejw(b, a, w);       
mag = abs(H);                  
ph  = unwrap(angle(H));        

%% First 20 impulse samples (no impz) 
L = 20;                       
h = impulse_response(b, a, L); 
n = (0:L-1).';               

%% Poles and zeros (for plotting) 
z = roots(b);                 
p2 = roots(a);                  

%% Magnitude, phase, pole-zero, and impulse 
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

%% First 20 impulse samples 
disp('First 20 samples of h[n] (n = 0..19):');
disp(table(n, h, 'VariableNames', {'n','h'}));

%% Local Functions

function H = H_of_ejw(b, a, w)
%   H(e^{jw}) = (sum_k b(k) e^{-jw(k-1)}) / (sum_k a(k) e^{-jw(k-1)})

    nb = length(b);                           
    na = length(a);                         

    Eb = exp(-1j*w*(0:nb-1));                
    Ea = exp(-1j*w*(0:na-1));               

    Num = Eb * b(:);                     
    Den = Ea * a(:);                       

    H = Num ./ Den;                         
end

function h = impulse_response(b, a, L)
%   y[n] = sum_{k=0}^{Nb-1} b[k] x[n-k] - sum_{k=1}^{Na-1} a[k] y[n-k]
% with x[0]=1 and x[n>0]=0.

    nb = length(b);                            
    na = length(a);                           

    x = zeros(L,1); x(1) = 1;                   
    y = zeros(L,1);                           

    for n = 1:L                                
        acc_num = 0;                           
        for k = 1:nb                       
            idx = n - (k-1);              
            if idx >= 1
                acc_num = acc_num + b(k)*x(idx);
            end
        end

        acc_den = 0;                         
        for k = 2:na                        
            idx = n - (k-1);                
            if idx >= 1
                acc_den = acc_den + a(k)*y(idx);
            end
        end

        y(n) = (acc_num - acc_den) / a(1);     
    end

    h = y;                 
end

function pz_plot(z, p)

    t = linspace(0, 2*pi, 400);               
    plot(cos(t), sin(t), 'k--'); hold on;       
    grid on; axis equal;                       

    if ~isempty(z)
        plot(real(z), imag(z), 'bo', 'LineWidth', 1.5); 
    end
    if ~isempty(p)
        plot(real(p), imag(p), 'rx', 'LineWidth', 1.5); 
    end

    xlabel('Real'); ylabel('Imag');           
    legend('Unit circle','Zeros','Poles','Location','best'); 
    xlim([-1.5 1.5]); ylim([-1.5 1.5]);  
end