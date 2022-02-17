using Sound: soundsc
using WAV: wavread
using FFTW; fft
using Plots

file = "project2.wav"
(X, S, _, _) = wavread(file)
soundsc(X, S)
@show N = length(X)

SNR = 10*log10(sum(x.^2) / sum(noise.^2))