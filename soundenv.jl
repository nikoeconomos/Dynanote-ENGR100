using MIRT: interp1
using Sound: soundsc
using Plots
using WAV: wavread

time = 100
freq = 460
type = "asdr"
y
S = 44100

function soundenv(time, freq, type)


    if type == "staccato"
        S = 44100
        N = Int(time * S)
        t = (0:N-1)/S
        c = 1 ./ (1:2:1000) # amplitudes    
        f = (1:2:1000) * freq # frequencies
        x = +([c[k] * sin.(2π * f[k] * t) for k in 1:length(c)]...) # !!
        env = (time .- exp.(-80*t)) .* exp.(-3*t) # fast attack; slow decay
        y = env .* x
        
    end

    if type == "asdr"
        S = 44100
        N = Int(time * S)
        t = (0:N-1)/S
        c = 1 ./ (1:2:1000) # amplitudes
        f = (1:2:1000) * freq # frequencies
        x = sin.(2π * t * f') * c
        env = interp1([0, time * 0.1, time * 0.2, time * 0.85, time], [0, 1, 0.3, 0.3, 0], t) # !! 
        y = env .* x
        
    end

end

soundsc(y, S)
