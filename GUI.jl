using Gtk
using Sound: sound, record
using MAT: matwrite
using Gtk.ShortNames, GtkReactive

# initialize two global variables used throughout
S = 7999 # sampling rate (samples/second) for this low-fi project
global song = Float32[] # initialize "song" as an empty vector
notneeded = Float32[]
global data;



function miditone(midi::Int; nsample::Int = 2000)
    f = 440 * 2^((midi- 69)/12) # compute frequency from midi number 
    x = cos.(2pi*(1:nsample)*f/S) # generate sinusoidal tone
    sound(x, S) # play note so that user can hear it immediately
    global song = [song; x] # append note to the (global) song vector
    return nothing
end


# define the white and black keys and their midi numbers 
white = ["G" 67; "A" 69; "B" 71; "C" 72; "D" 74; "E" 76;"F" 77; "G" 79]
black = ["G" 68 2; "A" 70 4; "C" 73 8; "D" 75 10; "F" 78 14]


g = GtkGrid() # initialize a grid to hold buttons
set_gtk_property!(g, :row_spacing, 5) # gaps between buttons
set_gtk_property!(g, :column_spacing, 5)
set_gtk_property!(g, :row_homogeneous, true) # stretch with window resize
set_gtk_property!(g, :column_homogeneous, true)

# CONFIGURING THE GUI
# define the "style" of the black keys
sharp = GtkCssProvider(data="#wb {color:white; background:black;}")
#  add a style for the end button
endbut = GtkCssProvider(data="#wb {color:yellow; background:blue;}")
clearbut = GtkCssProvider(data="#wb {color:black; background:red;}")
recordbut = GtkCssProvider(data="#wb {color:black; background:red;}")
reverbbut = GtkCssProvider(data="#wb {color:black; background:red;}")
delaybut = GtkCssProvider(data="#wb {color:black; background:red;}")
decaybut = GtkCssProvider(data="#wb {color:black; background:red;}")
attackbut = GtkCssProvider(data="#wb {color:black; background:red;}")
releasebut = GtkCssProvider(data="#wb {color:black; background:red;}")
tremolobut = GtkCssProvider(data="#wb {color:black; background:red;}")
sustainbut = GtkCssProvider(data="#wb {color:black; background:red;}")
logobut = GtkCssProvider(data="#wb {color:black; background:red;}")
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

function end_button_cliked(w) # callback function for "end" button
    println("The end button")
    sound(song, S) # play the entire song when user clicks "end"
    matwrite("proj1.mat", Dict("song" => song); compress=true) # save song to file
end

function clear_button_clicked(w)
    println("The clear button")
    global song = Float32[];
end

function record_stop_clicked(w)
    println("Record (Start & Stop)")
    S = 44100
    global data, S = record(2);
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

ebutton = GtkButton("Play") # make an "play" button
clearbutton = GtkButton("clear")

record_stop_button = GtkButton("Record ")
g[1:3,1:2] = record_stop_button
sustain_slider_button = GtkScale(false, 0:0.5:10)
g[4:9, 1:2] = sustain_slider_button
decay_button = GtkButton("Decay")
g[1:3,7:8] = decay_button
reverb_button = GtkButton("Reverb")
g[4:6, 7:8] = reverb_button 
attack_button  = GtkButton("Attack")
g[1:3, 4:5] = attack_button 
release_button  = GtkButton("Release")
g[4:6, 4:5] = release_button
tremolo_button  = GtkButton("Tremolo")
g[7:9, 7:8] = tremolo_button
delay_button = GtkButton("Delay")
g[7:9, 4:5]= delay_button
logo_button = GtkButton("DYNANOTE")
g[10:18, 1:2]= logo_button

g[10:12, 4:5] = ebutton # fill up entire row 3 of grid - why not?
g[1:3, 10:11] = clearbutton

set_gtk_property!(clearbutton, :name, "wb")
signal_connect(clear_button_clicked, clearbutton, "clicked")
push!(GAccessor.style_context(clearbutton), GtkStyleProvider(clearbut), 600)

set_gtk_property!(record_stop_button, :name, "wb")
signal_connect(record_stop_clicked, record_stop_button, "clicked")
push!(GAccessor.style_context(record_stop_button), GtkStyleProvider(recordbut), 600)

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

#sl = slider(1:11)
#set_gtk_property!(sustain_slider_button, :name, "wb")
#signal_connect(sustain_slider, sustain_slider_button, "slided")
#push!(GAccessor.style_context(sustain_slider_button), GtkStyleProvider(sustainbut), 600)
    
signal_connect(end_button_clicked, ebutton, "clicked") # callback

push!(GAccessor.style_context(ebutton), GtkStyleProvider(endbut), 600)

set_gtk_property!(ebutton, :name, "wb")


win = GtkWindow("DAW", 1000, 1000); # 400×300 pixel window for all the buttons
push!(win,g) # put button grid into the window
Gtk.showall(win); # display the window full of buttons