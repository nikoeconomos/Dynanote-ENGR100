#Niko Economos, ENGR 100
using Sound: phase_vocoder, soundsc, hann, record
using DSP: spectrogram
using MIRTjim: jim, prompt
using InteractiveUtils: versioninfo
using FFTW: fft, ifft
using WAV: wavread

function sustain()
    S = 44100
    
    #data, S = record(2);
    
    # t = (1:S/2)/S
    # data = cos.(2*pi*440*t)
    # @show length(data)

    file = "piano_note.wav" # adjust as needed
    (data, S, _, _) = wavread(file)
    D2 = 2/N2 * fft(data, 1) # 1D fft of each column of y2
    heatmap(abs.(D2), xlabel="time segment", ylabel="l=k+1") # spectrogram

    soundsc(data, S)

    p = plot(vec(data), ylabel="f [Hz]")

    
end