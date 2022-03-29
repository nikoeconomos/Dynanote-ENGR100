using Sound: phase_vocoder, soundsc, hann, record
using DSP: spectrogram
using MIRTjim: jim, prompt
using InteractiveUtils: versioninfo
using FFTW: fft, ifft

function sample_record(seconds, octaves, steps, pitch::String)
    S = 44100
    #data, S = record(2);
    
    t = (1:S/2)/S
    data = cos.(2*pi*440*t)
    @show length(data)

    soundsc(data, S)

    if pitch == "Decrease"
       
        N = length(data)

        #factor = 2^(steps/12) + octaves

        mod(N,2) == 0 || throw("N must be multiple of 2")
        F = fft(data) # original spectrum
        Fnew = [F[1:N÷2]; zeros(N * octaves); F[(N÷2+1):N]]
        Snew = 2 * real(ifft(Fnew))[1:N]
        @show length(Snew)
        soundsc(Snew, S)
    
    elseif pitch == "Increase"
        #needs to increase by one for hopin/hopout ratio
        octaves +=1
        y = phase_vocoder(data, S; hopin=121, hopout=(octaves*121))
        Y = y[1:octaves:end]
        @show length(Y)
        soundsc(Y,S)
    end
end