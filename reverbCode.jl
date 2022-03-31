using Sound
using Plots
using WAV: wavread


 S=44100
 t = (1:S/2)/S
 data = cos.(2*pi*400*t)
 soundsc(data,S);


D= 1000;
L= length(data);
show(L)
print("\n")
show(length(data[1:L-6*D]))
print("\n")
show(length(data[1+D:L-5*D]))
print("\n")
show(length(data[1+2*D:L-4*D]))
print("\n")
show(length(data[1+3*D:L-3*D]))
print("\n")
show(length(data[1+4*D:L-2*D]))
print("\n")
show(length(data[1+5*D:L-D]))
print("\n")
show(length(data[1+6*D:L]))
print("\n")
s= data[1:L-6*D] + data[1+D:L-5*D] + data[1+2*D:L-4*D]+data[1+3*D:L-3*D]+data[1+4*D:L-2*D]+data[1+5*D:L-D]+data[1+6*D:L];
#X=length(s)
s2= data+s;
soundsc(s2,S);
show(length(s))

