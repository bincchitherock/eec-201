% 1. Load the speech signals s1.mat and s5.mat (sampled at 8 kHz)
% 2. Construct narrowband spectrograms for both signals 
% using a triangular window and FFT lengths that are powers of two
% 3. window length, FFT length, and overlap to obtain 
% high frequency resolution (narrowband)
% 4. Use these spectrograms to estimate the fundamental 
% frequency (pitch) as it changes over time.
% 5. Sketch the fundamental frequency trajectory
% for both speech signals 

load s1
load s5

fs = 8000;

Nw = 512;
Nfft = 1024;
Noverlap = 511;

figure;
spectrogram(s1, triang(Nw), Noverlap, Nfft, fs, 'yaxis');
title('Narrowband Spectrogram of s1');

figure;
spectrogram(s5, triang(Nw), Noverlap, Nfft, fs, 'yaxis');
title('Narrowband Spectrogram of s5');

