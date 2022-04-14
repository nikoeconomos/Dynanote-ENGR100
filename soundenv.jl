using MIRT: interp1
using Sound: soundsc
using Plots
using WAV: wavread



file = "/Users/ian/Documents/GitHub/engr100-trombones/piano_note.wav"
(x, S, _, _) = wavread(file)
data = x[:,1]
soundsc(data, S)

function fast_attack_decay(stuff)
    N = length(data)
    time = (0:N-1)/S
    env = (time .- exp.(-80*time)) .* exp.(-3*time) # fast attack; slow decay
    y = env .* stuff
    return y
end

function asdr(stuff)
    N = length(data)
    time = (0:N-1)/S
    a = time * 0.1
    b = time * 0.2
    c = time * 0.85
    d = time * 1
    env = interp1([0, a, b, c, d], [0, 1, 0.3, 0.3, 0], time) # !! 
    y = env .* stuff
    return y
end

#lol = fast_attack_decay(data)
lol = asdr(data)
soundsc(lol, S)
