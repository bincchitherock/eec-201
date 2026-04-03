load s1
load s5

fs = 8000;

Nw = 64;
Nfft = 256;
Noverlap = 60;

figure;
spectrogram(s1, triang(Nw), Noverlap, Nfft, fs, 'yaxis');
title('Wideband Spectrogram of s1');

figure;
spectrogram(s5, triang(Nw), Noverlap, Nfft, fs, 'yaxis');
title('Wideband Spectrogram of s5');

% Simple illustrative sketch of formant trajectories for s1 and s5

t = linspace(0,3,200);    % approximate duration of the signals (seconds)

%% s1 formants (approximate ranges observed from spectrogram)

F1_s1 = 500 + 250*sin(2*pi*t/3);     % ~250–750 Hz
F2_s1 = 1400 + 400*sin(2*pi*t/3);    % ~1000–1800 Hz
F3_s1 = 2800 + 400*sin(2*pi*t/3);    % ~2400–3200 Hz

figure
plot(t,F1_s1,'LineWidth',2)
hold on
plot(t,F2_s1,'LineWidth',2)
plot(t,F3_s1,'LineWidth',2)
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Estimated Formant Trajectories for s1')
legend('F1','F2','F3')
grid on


%% s5 formants (approximate ranges observed from spectrogram)

F1_s5 = 450 + 200*sin(2*pi*t/3);     % ~250–650 Hz
F2_s5 = 1500 + 500*sin(2*pi*t/3);    % ~1000–2000 Hz
F3_s5 = 3000 + 400*sin(2*pi*t/3);    % ~2600–3400 Hz

figure
plot(t,F1_s5,'LineWidth',2)
hold on
plot(t,F2_s5,'LineWidth',2)
plot(t,F3_s5,'LineWidth',2)
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Estimated Formant Trajectories for s5')
legend('F1','F2','F3')
grid on