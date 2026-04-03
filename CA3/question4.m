%% Question 4: Comparing the Order of the Three Filter Design Methods
% wp = 0.45pi, sb cutoff ws = 0.5pi, PB ripple = 0.1 dB, SB atten below 40
% dB. using buttord, cheb1ord, f200c ellipord commands. 

clear; close all; clc;

wp = 0.45; 
ws = 0.50;  
Rp = 0.1;  
Rs = 40;  

%% Minimum order for each method
[Nb, Wnb] = buttord(wp, ws, Rp, Rs);      % Method 1: Butterworth
[Nc, Wnc] = cheb1ord(wp, ws, Rp, Rs);     % Method 2: Chebyshev Type I
[Ne, Wne] = ellipord(wp, ws, Rp, Rs);     % Method 3: Elliptic

fprintf('Butterworth: N = %d, Wn = %.6f\n', Nb, Wnb);
fprintf('Chebyshev I: N = %d, Wn = %.6f\n', Nc, Wnc);
fprintf('Elliptic   : N = %d, Wn = %.6f\n', Ne, Wne);

%% Finding the lowest-order method

Ns = [Nb Nc Ne];
names = {'Butterworth','Chebyshev I','Elliptic'};
[minN, idx] = min(Ns);

fprintf('\nLowest order meeting specs: %s (N = %d)\n', names{idx}, minN);

%% Method of verification: designing each filter at its minimum order
[bb,ab] = butter(Nb, Wnb, 'low');
[bc,ac] = cheby1(Nc, Rp, Wnc, 'low');
[be,ae] = ellip(Ne, Rp, Rs, Wne, 'low');

nfft = 4096;
[Hb,w] = freqz(bb,ab,nfft);
[Hc,~] = freqz(bc,ac,nfft);
[He,~] = freqz(be,ae,nfft);

figure('Name','Magnitude Responses','Color','w');
plot(w/pi, 20*log10(max(abs(Hb),1e-12))); hold on; grid on;
plot(w/pi, 20*log10(max(abs(Hc),1e-12)));
plot(w/pi, 20*log10(max(abs(He),1e-12)));
xline(wp,'--'); xline(ws,'--');
yline(-Rp,'--'); yline(-Rs,'--');
xlabel('\omega/\pi'); ylabel('Magnitude (dB)');
legend('Butterworth','Chebyshev I','Elliptic','Location','SouthWest');
title('Meets specs if curves stay above -Rp in passband and below -Rs in stopband');