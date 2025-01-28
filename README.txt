DYNANOTE
By: Team Trombones

This project was completed in ENGR 100, the first year engineering design experience. This section was about digital signal processing for musical applications. We built a synthesizer that records sounds and modifies the resulting digital signal in pitch, envelope, effects, etc.
------------------
INSTRUCTIONS:

*Note that to run the program on your system, you will likely
need to install a few Julia packages. The REPL should give you the 
command needed to install the package(s): Pfg.add("Package")

1. In the Julia REPL, type include("DYNANOTE.jl") to run the program.

*You may receive warnings in the terminal when running the 
program, which can be ignored.

2. Running the programn will bring you to the main GUI. This 
GUI contains buttons for various sound modifications.

3. To get started, press the record button.

4. Add various sound modifications as desired. Pressing the "play" button will
play the sound back. Pressing the "clear" button allows you to start over.

*In our prototype, the only modifcations avaliable are sustain (Whole Note, Half Note, and
Quarter Note only), ADSR, Attack-Decay, Reverb, and Tremolo. Functionality will be expanded in future iterations.

5. Once you have made the various modifcations, press the "Generate Synthesizer" button. This will generate another GUI, a piano, in which you can 
record and play back a song with your edited sample.

*In our current prototype, the synthesizer only supports generating add 
synthesizer from an original sample and a sample with Tremolo added to it.
