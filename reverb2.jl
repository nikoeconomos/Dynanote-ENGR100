using Sound: soundsc, sound
using Plots
using WAV: wavread

#read in music
S = 44100
file = "c:/Users/sravy/.julia/engr100-trombones/piano_note.wav"
(data, S, _, _) = wavread(file)
dataVec = data[:,1]
#sound(dataVec,S)

L= length(dataVec)
#determine division length for echoes
d= (floor(L/4))
D= trunc(Int, d)


#add cushion zeroes to end of dataVec
cushion = zeros(4*D)
BaseSound= Float32[]
append!(BaseSound, dataVec, 44100)
append!(BaseSound, cushion, 44100)
#sound(BaseSound, 44100)

EchoOne= Float32[]
append!(EchoOne, zeros(D-1), 44100)
append!(EchoOne, dataVec, 44100)
append!(EchoOne, zeros(3*D), 44100)
EchoOne= EchoOne.*0.7

EchoTwo= Float32[]
append!(EchoTwo, zeros((2*D)-1), 44100)
append!(EchoTwo, dataVec, 44100)
append!(EchoTwo, zeros(2*D), 44100)
EchoTwo= EchoTwo.*0.5

EchoThree= Float32[]
append!(EchoThree, zeros((3*D)-1), 44100)
append!(EchoThree, dataVec, 44100)
append!(EchoThree, zeros(D), 44100)
EchoThree= EchoThree.*0.3

EchoFour= Float32[]
append!(EchoFour, zeros((4*D)-1), 44100)
append!(EchoFour, dataVec, 44100)
EchoFour= EchoFour.*0.1

finalSound=BaseSound+EchoOne+EchoTwo+EchoThree
sound(finalSound, 44100)
show(length(finalSound))
show(L+(4*D))












