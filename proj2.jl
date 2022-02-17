using Sound: soundsc
using WAV: wavread
using FFTW; fft
using Plots; default(label="")
plotly();

file = "project2.wav"
(X, S,) = wavread(file)
soundsc(X, S)


@show N = (length(X) ÷ 12)
y = reshape(X, N, 12)
plot(y[1:100, 1])


Z = abs.(fft(y, 1))

i = 1
    c = 2:N÷2
    n = Z[:,i]
    min = 10;
    peak = (n[c] > n[c - 1]) & (n[c] > n[c + 1]) & (n[c] > min)
    @show i, 
  
plot(abs.(Z), xlabel="frequency index l=k+1", ylabel="Z[l]")
