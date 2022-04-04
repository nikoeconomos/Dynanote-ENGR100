# sound envelope modifications

using MIRT: interp1 # one of many Julia interpolators
S = 44100
N = Int(1.5 * S)
t = (0:N-1)/S
c = 1 ./ (1:2:15) # amplitudes
f = (1:2:15) * 494 # frequencies
x = sin.(2π * t * f') * c
env = interp1([0, 0.1, 0.3, 1.1, 1.5], [0, 1, 0.4, 0.4, 0], t) # !! 
y = env .* x
