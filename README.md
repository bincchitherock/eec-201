# eec-201
<winter 2026> compilation of matlab projects from eec 201, graduate digital signal processing.

## repository structure

```
.
├── CA3/
│   ├── q1_butterworth.m            # 6th-order Butterworth LPF (toolbox)
│   ├── q1_butterworth_manual.m     # 6th-order Butterworth LPF (no toolbox — manual bilinear transform)
│   ├── q2_chebyshev.m              # 6th-order Chebyshev Type I LPF
│   ├── q3_elliptic.m               # 6th-order Elliptic LPF
│   ├── q4_order_comparison.m       # Minimum order comparison: Butterworth vs Chebyshev vs Elliptic
│   ├── q5_rect_hamming.m           # 29-point FIR LPF: rectangular and Hamming windows
│   ├── q6_kaiser.m                 # 29-point FIR LPF: Kaiser window (β = 4, 6)
│   ├── q7_firpm_optimal.m          # Optimal equiripple FIR (Parks-McClellan) with alternation points
│   ├── q8_vary_passband.m          # Effect of varying passband edge on firpm ripple
│   ├── q9_vary_transition.m        # Effect of varying transition bandwidth on firpm ripple
│   ├── q10_optimal_vs_window.m     # Optimal (firpm) vs Kaiser window FIR comparison
│   ├── q11_filter_length.m         # Effect of increasing filter length (N = 29 vs 39)
│   ├── q12_fir2_comparison.m       # Frequency-sampling FIR (fir2) at N = 29 and N = 39
│   └── Report-CA3.pdf
│
├── CA4/
│   ├── q1_chirp.m                  # Linear FM chirp signal generation + spectrogram
│   ├── q3_chirp_aliased.m          # Higher chirp rate (μ = 10^10) demonstrating aliasing
│   ├── q4_narrowband.m             # Narrowband spectrograms of speech signals (pitch estimation)
│   ├── q5_wideband.m               # Wideband spectrograms of speech signals (formant estimation)
│   ├── q6_test.m                   # STFT reconstruction verification
│   ├── istft_estimate.m            # Inverse STFT via overlap-add averaging
│   ├── s1.mat                      # Speech signal 1 (8 kHz)
│   ├── s5.mat                      # Speech signal 5 (8 kHz)
│   ├── vowels.mat                  # Vowel signal for STFT reconstruction
│   └── Report-CA4.pdf
│
└── README.md
```

---

## assignment summaries

### ca1 — z-transforms, frequency response, and convolution

explored the relationship between z-domain representations and time/frequency-domain behavior of lti systems. key tasks:

- derived transfer function coefficients for a damped cosine impulse response and verified via `filter()` and `residuez()`
- investigated how pole radius *r* controls resonance peak height and 3 db bandwidth (Δω ∝ 1 − r)
- demonstrated 2π-periodicity of pole angles in the z-plane
- analyzed a 3rd-order causal iir system: pole-zero plot, roc, dc gain verification, steady-state response to composite sinusoidal input
- compared time-domain convolution with inverse-dtft (ifft) reconstruction — agreement to ~10⁻¹⁴

### ca2 — multirate sample rate conversion

implemented a three-stage rational sample rate converter to upsample audio from 11.025 khz to 24 khz using the factorization:

$$\frac{24000}{11025} = \frac{10}{7} \times \frac{8}{7} \times \frac{4}{3}$$

- each stage: interpolation → kaiser-window fir lowpass → decimation
- 30 db stopband attenuation; fir orders 154, 124, 62 across stages
- duration preserved to within ~70 μs over a 154-second recording
- **bonus:** built a real-time matlab gui with waveform display, short-time rms envelope (dbfs), live level meters with peak-hold, and playback scrubbing

### ca3 — iir and fir filter design

systematic comparison of digital filter design methods, all targeting a lowpass response with ωc = 0.33π:

| filter type | design method | key observation |
|---|---|---|
| butterworth | `butter` + manual bilinear transform | maximally flat; highest order for tight specs |
| chebyshev i | `cheby1` | passband ripple trades for sharper rolloff |
| elliptic | `ellip` | ripple in both bands → lowest order (n = 7 vs 42 for butterworth) |
| fir (window) | rectangular, hamming, kaiser (β = 4, 6) | increasing β reduces ripple but widens transition band |
| fir (optimal) | `firpm` (parks-mcclellan) | equiripple; smaller δp and δs than kaiser for same n |

additional investigations: effect of passband edge, transition bandwidth, and filter length on equiripple fir performance. alternation points were visually identified and counted to confirm chebyshev optimality.

**extension:** the butterworth filter was also designed entirely without the signal processing toolbox. i.e., the analog poles were placed manually, mapped to the z-plane via the bilinear transform, and the frequency response was evaluated directly from the transfer function definition.

### ca4 — time-frequency analysis (stft and spectrograms)

- **fm chirp signals:** generated a linear fm chirp (μ = 4 × 10⁹), verified that instantaneous frequency fi(t) = 2μt matches the spectrogram ridge, and demonstrated spectral aliasing when μ is increased to 10¹⁰ (ridge folds back at the nyquist frequency ~125 μs into the signal)
- **speech spectrograms:** constructed narrowband (nw = 512) and wideband (nw = 64) spectrograms of two speech signals to estimate fundamental frequency trajectories and formant frequencies (f1, f2, f3) respectively
- **stft inversion:** wrote `istft_estimate.m` to reconstruct a time-domain signal from its modified stft using overlap-add averaging with conjugate-symmetric spectrum reconstruction

---

## requirements

- **matlab r2024a** or later (earlier versions likely work but are untested)
- **signal processing toolbox** required for `butter`, `cheby1`, `ellip`, `firpm`, `freqz`, `spectrogram`, `kaiserord`, `audioplayer`, etc.
- **audio toolbox** optional, used only by `wav_meter_gui.m` for real-time playback

---

## usage

each script is self-contained. navigate to the relevant assignment folder and j run. 

---

## etc.

- all fir window designs use odd-length filters (type i linear phase) unless otherwise noted.
- frequency axes are normalized to π rad/sample where applicable; matlab's convention uses the [0, 1] scale where 1 corresponds to π.
- the `istft_estimate.m` function assumes a rectangular window, 1024-point fft, 256-sample window length, and 128-sample hop. modify internal parameters if using different stft settings.
