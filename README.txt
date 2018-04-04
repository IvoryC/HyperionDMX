DMX Files README
by Ivory Blakley
IvoryEC@gmail.com
for the TSN Hyperion build
Started 10 April 2016 (Artemis Armada 2)

Whats here:

DMX_Lights_ID_list.xls - Excel file used to track DMX devices, channels, and commands

DMXcommands-ConsoleCommons.xml - DMX file describing the ship status and red alert indicators (common to all stations)

DMX files for each console:
DMXcommands-Communications.xml
DMXcommands-Engineering.xml
DMXcommands-Helm.xml
DMXcommands-Science.xml
DMXcommands-Weapons.xml
DMXcommands-Ambiance.xml

assembleDMXprofile.R - Script to assemble files into one.  (The R program can be downloaded for free. So can the three packages this scripts uses.  The MegaMaster is already assembled. This script only needs to be run if any of the starting files are edited)

Final assembled DMX file:
DMXcommands-MegaMaster


How it works:

Editing a single large xml file was unruly and prone to inconsistency.  The status indicator at the left side of the console is the same for all consoles, and those DMX commands are in DMXcommanmds-ConsoleCommons.xml.  This file, and each of the individual console files, is a self sufficient script that can be tested as a stand-alone DMX file. Each file also has the key phrase “Start copy range” and “End copy range” indicating the range that should copied into the final assembled dmx file.  The assembly script copies the ConsoleCommons and uses the information from DMX_Lights_ID_list.xls to change the template ids (1-10) to the appropriate id set for each console.  If we only had one dmx board, we would only need channels 1-10 for the set, but each console gets its own board, and they can't share a set of 10 common ids and then have 20 separate ones---hence, we have the same information being fed to 5 sets of 10 channels.  

The assembly script 
1) uses the xls file to make the Normal Condition 1 command and the Always on command for each device, 
2) makes the console commons portion for each console, and 
3) copies the copy range from each console's file into the single MegaMaster dmx file.  

When using only the base game, this assembled file should be placed in ProgramFiles/Artemis/dat and named DMXcommands.xml.  
However, we wanted to use the extra DMX commands available from the ArtemisBridgeTools mod.  When using this, the file needs to be placed in C:\Users\Artemis\AppData\Local\ArtemisBridgeTools (with any name) and the file must be selected as the active profile in the ArtemisDmxEditor GUI, and the ArtemisDmxEditor mod needs to be linked to the Artemis exe location.   The ArtemisDmxEditor is an excellent testing and trouble shooting tool.  The editing ability is also very nice (not everyone likes to make scripts to make xml files).  My compliments to its author.  And I am so glad it is robust to version changes in the game. :)

The commands that made me think of the mod as essential were the warp drive (1-4) commands.  Even early on, we had plans for building a warp core.  In the xls file, in the sheet “Event Responses”, you can see a list of all the commands we use (if there is a console and description listed), or planned to use in the near future (if there is a ? in the Console column). The base/mod column indicates which commands are from the base (Artemis game) or the mod (ArtemisBridgeTools).  

Early on our hardware also mandated using the mod.  For reasons I don't fully understand, two of our five dmx boards only support dmxpro (they are a different style and brand than the other three).  The mod allows for dmxopen or dmxpro.  Our initial solution was to use DMXpro for everything.  Since then, we have replaced those two boards and now we use DMXopen for everything.


Our ships history in the Artemis Armada:
Artemis Armada 1 - we were a laptop bridge.
Artemis Armada 2 - we made the consoles and got matching uniforms
Artemis Armada 3 - we added the warp core
Artemis Armada 4 - added jams
