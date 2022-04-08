using Gtk: GtkGrid, GtkButton, GtkWindow, GAccessor, GtkScale
using Gtk: GtkCssProvider, GtkStyleProvider, GtkImage
using Gtk: set_gtk_property!, signal_connect, showall
using PortAudio: PortAudioStream
using MAT: matwrite
using Gtk.ShortNames, GtkReactive
using PNGFiles
using Sound: phase_vocoder, hann, record, sound
using DSP: spectrogram
using MIRTjim: jim, prompt
using InteractiveUtils: versioninfo
using FFTW: fft, ifft

notneeded = Float32[]

const S = 44100 # sampling rate (samples/second)
const N = 1024 # buffer length
const maxtime = 10 # maximum recording time 10 seconds (for demo)
recording = nothing # flag
nsample = 0 # count number of samples recorded
song = nothing # initialize "song"
global data = Float32[]


function miditone(midi::Int; nsample::Int = 2000)
    f = 440 * 2^((midi- 69)/12) # compute frequency from midi number 
    x = cos.(2pi*(1:nsample)*f/S) # generate sinusoidal tone
    soundsc(x, S) # play note so that user can hear it immediately
    global data = [data; x] # append note to the (global) song vector
    return nothing
end


# define the white and black keys and their midi numbers 
white = ["F" 53; "G" 55; "A" 57; "B" 59; "C" 60; "D" 62; "E" 64;"F" 65; "G" 67; "A" 69; "B" 71; "C" 72; "D" 74; "E" 76;"F" 77]
black = ["F" 54 2; "G" 56 4; "A" 58 6; "C" 61 10; "D" 63 12;"F" 66 16; "G" 68 18; "A" 70 20; "C" 73 24; "D" 75 26]


g = GtkGrid() # initialize a grid to hold buttons
set_gtk_property!(g, :row_spacing, 5) # gaps between buttons
set_gtk_property!(g, :column_spacing, 5)
set_gtk_property!(g, :row_homogeneous, true) # stretch with window resize
set_gtk_property!(g, :column_homogeneous, true)

# CONFIGURING THE GUI
# define the "style" of the black keys
sharp = GtkCssProvider(data="#wb {color:white; background:black;}")
#  add a style for the end button
label = Label("Hello")
clearbut = GtkCssProvider(data="#wb {color:white; background:black;}")
reverbbut = GtkCssProvider(data="#wb {color:white; background:black;}")
delaybut = GtkCssProvider(data="#wb {color:white; background:black;}")
decaybut = GtkCssProvider(data="#wb {color:white; background:black;}")
attackbut = GtkCssProvider(data="#wb {color:white; background:black;}")
releasebut = GtkCssProvider(data="#wb {color:white; background:black;}")
tremolobut = GtkCssProvider(data="#wb {color:white; background:black;}")
sustainbut = GtkCssProvider(data="#wb {color:white; background:black;}")
logobut = GtkCssProvider(data="#wb {color:white; background:black;}")
whole_note_but = GtkCssProvider(data="#wb {color:white; background:black;}")
half_note_but = GtkCssProvider(data="#wb {color:white; background:black;}")
quarter_note_but = GtkCssProvider(data="#wb {color:white; background:black;}")
eighth_note_but = GtkCssProvider(data="#wb {color:white; background:black;}")
sixteenth_note_but = GtkCssProvider(data="#wb {color:white; background:black;}")





for i in 1:size(white,1) # add the white keys to the grid
    key, midi = white[i,1:2]
    b = GtkButton(key) # make a button for this key
    signal_connect((w) -> miditone(midi), b, "clicked") # callback
    g[(1:2) .+ 2*(i-1), 15] = b # put the button in row 2 of the grid
end

for i in 1:size(black,1) # add the black keys to the grid
    key, midi, start = black[i,1:3] 
    b = GtkButton(key * "♯") # to make ♯ symbol, type \sharp then hit <tab>
    push!(GAccessor.style_context(b), GtkStyleProvider(sharp), 600)
    set_gtk_property!(b, :name, "wb") # set "style" of black key
    signal_connect((w) -> miditone(midi), b, "clicked") # callback
    g[start .+ (0:1), 14] = b # put the button in row 1 of the grid
end

function call_play(w) # callback function for "end" button
    println("Play")
    @async sound(song, S) # play the entire recording
    sound(data, S)
    matwrite("proj1.mat", Dict("song" => song); compress=true) # save song to file 
end

function call_stop(w)
    global recording = false
    global nsample
    duration = round(nsample / S, digits=2)
    sleep(0.1) # ensure the async record loop finished
    flush(stdout)
    println("\nStop at nsample=$nsample, for $duration out of $maxtime sec.")
    global song = song[1:nsample] # truncate song to the recorded duration
end

function call_record(w)
    global N
    in_stream = PortAudioStream(1, 0) # default input device
    buf = read(in_stream, N) # warm-up
    global recording = true
    global song = zeros(Float32, maxtime * S)
    @async record_loop!(in_stream, buf)
    nothing
end

function make_button(string, callback, column, stylename, styledata)
    b = GtkButton(string)
    signal_connect((w) -> callback(w), b, "clicked")
    g[column,3:4] = b
    s = GtkCssProvider(data = "#$stylename {$styledata}")
    push!(GAccessor.style_context(b), GtkStyleProvider(s), 600)
    set_gtk_property!(b, :name, stylename)
    return b
end

br = make_button("Record", call_record, 10:12, "wr", "color:white; background:black;")
bs = make_button("Stop", call_stop, 13:15, "yb", "color:white; background:black;")
bp = make_button("Play", call_play, 16:18, "wg", "color:white; background:black;")
function record_loop!(in_stream, buf)
    global maxtime
    global S
    global N
    global recording
    global song
    global nsample
    Niter = floor(Int, maxtime * S / N)
    println("\nRecording up to Niter=$Niter ($maxtime sec).")
    for iter in 1:Niter
        if !recording
            break
        end
        read!(in_stream, buf)
        song[(iter-1)*N .+ (1:N)] = buf # save buffer to song
        nsample += N
        print("\riter=$iter/$Niter nsample=$nsample")
    end
    nothing
end

function clear_button_clicked(w)
    println("The clear button")
    global data = Float32[];
    global song = nothing;
end


function decay_clicked(w)
    println("Decay");
end

function attack_clicked(w)
    println("Attack");
end

function release_clicked(w)
    println("Release");
end
function reverb_clicked(w)
    println("Reverb");
end

function tremolo_clicked(w)
    println("Tremolo");
end
function delay_clicked(w)
    println("Delay")
      
end

function sustain_slider(w)
    println("Sustain")

end

function whole_note(w)
    println("Whole Note")

end

function half_note(w)
    println("Half Note")

end


function quarter_note(w)
    println("Quarter Note")

end

function eighth_note(w)
    println("Eight Note")

end

function sixteenth_note(w)
    println("Sixteenth Note")

end


clearbutton = GtkButton("clear")
g[1:3, 10:11] = clearbutton
sustain_slider_button = slider(1:0.5:10)
text_box = textbox(Float64; signal=signal(sustain_slider_button))
g[1:9, 3:4] = text_box
g[1:9, 1:2] = sustain_slider_button
decay_button = GtkButton("Decay")
g[1:3,7:8] = decay_button
reverb_button = GtkButton("Reverb")
g[4:6, 7:8] = reverb_button 
attack_button  = GtkButton("Attack")
g[1:3, 5:6] = attack_button 
release_button  = GtkButton("Release")
g[4:6, 5:6] = release_button
tremolo_button  = GtkButton("Tremolo")
g[7:9, 7:8] = tremolo_button
delay_button = GtkButton("Delay")
g[7:9, 5:6]= delay_button
logo_button = GtkButton("DYNANOTE")
g[10:18, 1:2]= logo_button
whole_note_button = GtkButton("Whole Note")
g[10:12, 7:8] = whole_note_button
half_note_button = GtkButton("Half Note")
#g[10:12, 13:15] = half_note_button 
quarter_note_button = GtkButton("Quarter Note")
#g[13:15, 16:18] = quarter_note_button
eighth_note_button = GtkButton("Eight Note")
#g[7:9, 10:12] = eighth_note_button
sixteenth_note_button = GtkButton("Sixteenth Note") 
#g[10:12, 13:15] = sixteenth_note_button
img_back = GtkImage("Image .jpeg")
g[1:18,1:18] = img_back

set_gtk_property!(clearbutton, :name, "wb")
signal_connect(clear_button_clicked, clearbutton, "clicked")
push!(GAccessor.style_context(clearbutton), GtkStyleProvider(clearbut), 600)

set_gtk_property!(decay_button, :name, "wb")
signal_connect(decay_clicked, decay_button, "clicked")
push!(GAccessor.style_context(decay_button), GtkStyleProvider(decaybut), 600)

set_gtk_property!(reverb_button, :name, "wb")
signal_connect(reverb_clicked, reverb_button, "clicked")
push!(GAccessor.style_context(reverb_button), GtkStyleProvider(reverbbut), 600)

set_gtk_property!(attack_button, :name, "wb")
signal_connect(attack_clicked, attack_button, "clicked")
push!(GAccessor.style_context(attack_button), GtkStyleProvider(attackbut), 600)

set_gtk_property!(release_button, :name, "wb")
signal_connect(release_clicked, release_button, "clicked")
push!(GAccessor.style_context(release_button), GtkStyleProvider(releasebut), 600)

set_gtk_property!(logo_button, :name, "wb")
push!(GAccessor.style_context(logo_button), GtkStyleProvider(logobut), 600)

set_gtk_property!(tremolo_button, :name, "wb")
signal_connect(tremolo_clicked, tremolo_button, "clicked")
push!(GAccessor.style_context(tremolo_button), GtkStyleProvider(tremolobut), 600)

set_gtk_property!(delay_button, :name, "wb")
signal_connect(delay_clicked, delay_button, "clicked")
push!(GAccessor.style_context(delay_button), GtkStyleProvider(delaybut), 600)

set_gtk_property!(whole_note_button, :name, "wb")
signal_connect(whole_note, whole_note_button, "clicked")
push!(GAccessor.style_context(whole_note_button), GtkStyleProvider(whole_note_but), 600)

set_gtk_property!(half_note_button, :name, "wb")
signal_connect(half_note, half_note_button, "clicked")
push!(GAccessor.style_context(half_note_button,), GtkStyleProvider(half_note_but), 600)

set_gtk_property!(quarter_note_button, :name, "wb")
signal_connect(quarter_note, quarter_note_button, "clicked")
push!(GAccessor.style_context(quarter_note_button), GtkStyleProvider(quarter_note_but), 600)

set_gtk_property!(eighth_note_button, :name, "wb")
signal_connect(eighth_note, eighth_note_button, "clicked")
push!(GAccessor.style_context(eighth_note_button), GtkStyleProvider(eighth_note_but), 600)

set_gtk_property!(sixteenth_note_button, :name, "wb")
signal_connect(sixteenth_note, sixteenth_note_button, "clicked")
push!(GAccessor.style_context(sixteenth_note_button), GtkStyleProvider(sixteenth_note_but), 600)

win = GtkWindow("DAW", 1000, 1000); # 400×300 pixel window for all the buttons
push!(win,g) # put button grid into the window
Gtk.showall(win); # display the window full of buttons