#Niko Economos, ENGR 100
using Sound: soundsc, record
using DSP: spectrogram
using MIRTjim: jim, prompt
using InteractiveUtils: versioninfo
using FFTW: fft, ifft
using WAV: wavread
using Plots; default(label="")

function sustain()
    S = 44100
    
    #data, S = record(2);
    
    # t = (1:S/2)/S
    # data = cos.(2*pi*440*t)
    # @show length(data)

    file = "piano_note.wav"
    (data, S, _, _) = wavread(file)
    data = data[:, 1]
    data = vec(data)
    N = length(data)
    D2 = 2/N * fft(data, 1) # 1D fft of each column of y2

    p1 = plot(abs.(D2), xlabel="frequency index l=k+1", ylabel="|Y[l]|")
    xlims!(1, 1+N÷2);
    p2 = heatmap(abs.(D2), xlabel="time segment", ylabel="l=k+1") # 
    p3 = plot(data, ylabel="amplitude")

    #plot(p1, p2, p3)
    plot(p2)



    #soundsc(data, S)


end

sustain()