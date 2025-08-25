Crush Roller Arcade for the Tang Nano 9K FPGA Dev Board. Pinballwiz.org 2025
Code from MikeJ.

Notes:
Setup for keyboard controls in Upright mode (5 = Coin) (Start P1 = 1) (Start P2 = 2)(Arrow Keys = Move L or R or U or D)
Consult the Schematics Folder for Information regarding peripheral connections.

Build:
* Obtain correct roms file for Crush Roller (see scripts in tools folder for rom details).
* Unzip rom files to the tools folder.
* Run the make crushroller proms script in the tools folder.
* Place the generated prom files inside the proms folder.
* Open the TN9K-CrushRoller project file using GoWin.
* Compile the project updating filepaths to source files as necessary.
* Program Tang Nano 9K Board.
