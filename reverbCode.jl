using Sound

# S = 44100
# N = Int(0.5 * S) # 0.5 sec
# t = (0:N-1)/S # time samples: t = n/S
# y = 0.5 * cos.(2π * 400 * t);
S=44100
t = (1:S/2)/S
data = cos.(2*pi*400*t)
soundsc(data,S);
D= 10;
L= length(data);
s= data[1:L-2*D] + data[1+D:L-D] + data[1+2*D:L] + data[1+2*D:L]
s2= reshape(s, 22030, :)
soundsc(s2,S);

