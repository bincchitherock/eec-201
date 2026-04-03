load vowels

x = vowels;              % original signal
L = length(x);

Nw = 256;
Nfft = 1024;
Noverlap = 128;

[S, F, T] = spectrogram(x, rectwin(Nw), Noverlap, Nfft);

% reconstruct the signal from unmodified STFT
y = istft_estimate(S, L);

% error signal
e = x - y;

figure;
subplot(3,1,1);
plot(x);
title('Original Signal');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(3,1,2);
plot(y);
title('Reconstructed Signal from STFT');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(3,1,3);
plot(e);
title('Difference: Original - Reconstructed');
xlabel('Sample Index');
ylabel('Error');

% numerical error check just to be safe!!
fprintf('Maximum absolute error = %g\n', max(abs(e)));
fprintf('Mean squared error = %g\n', mean(e.^2));