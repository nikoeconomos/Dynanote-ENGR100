using Sound: soundsc, sound
using Plots
using WAV: wavread


S = 44100
t = (1:S/2)/S
data = cos.(2*pi*440*t)


D= 2000
L= length(data)
# show(L)
# print("\n")
# show(length(data[1:L-6*D]))
# print("\n")
# show(length(data[1+D:L-5*D]))
# print("\n")
# show(length(data[1+2*D:L-4*D]))
# print("\n")
# show(length(data[1+3*D:L-3*D]))
# print("\n")
# show(length(data[1+4*D:L-2*D]))
# print("\n")
# show(length(data[1+5*D:L-D]))
# print("\n")
# show(length(data[1+6*D:L]))
# print("\n")
totalEchoOne = Float32[]
echoOne = data[1:L-6*D]
lengthEchoOne = length(echoOne)
zeroes = zeros(L-lengthEchoOne-2)
# append!(totalEchoOne, zeroes, 44100)
# append!(totalEchoOne, echoOne, 44100)


echoes=[1]
for index in 1:length(echoes)
    echoPtOne=data[1+index*D]
    echoPtTwo=data[L-(6-index)*D]
    append!(totalEchoOne, echoPtOne, 44100)
    append!(totalEchoOne, zeroes, 44100)
    append!(totalEchoOne, echoPtTwo, 44100)
end
show(length(totalEchoOne))
# final=totalEchoOne+data;
# sound(final, 44100)
#+ data[1+D:L-5*D] + data[1+2*D:L-4*D]+ data[1+3*D:L-3*D]+ data[1+4*D:L-2*D]+ data[1+5*D:L-D]+data[1+6*D:L]
# sLength= length(s)
# #l=L=sLength
# soundsc(s, 44100)



