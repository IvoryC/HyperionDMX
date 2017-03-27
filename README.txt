DMX Files README
by Ivory Blakley
IvoryEC@gmail.com
for the TSN Hyperion build
10 April 2016 (Artemis Armada 2)

Files are listed followed by description of how files relate to each other, and then description of why we used the ArtemisBridgeTools mod.

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


Notes on how the DMX files are laid out:  
This may seem complicated, but it was the easiest way to keep track of this many devices and commands.  Just editing a single large xml file was unruly and prone to inconsistency.  The status indicator at the left side of the console is the same for all consoles, and those DMX commands are in DMXcommanmds-ConsoleCommons.xml.  This file, and each of the individual console files, is a self sufficient script that can be tested as a stand-alone DMX file. Each file also has the key phrase “Start copy range” and “End copy range” indicating the range that should copied into the final assembled dmx file.  The assembly script copies the ConsoleCommons and uses the information from DMX_Lights_ID_list.xls to change the template ids (1-10) to the appropriate id set for each console.  If we only had one dmx board, we would only need channels 1-10 for the set, but each console gets its own board, and they can't share a set of 10 common ids and then have 20 separate ones---hence, we have the same information being fed to 5 sets of 10 channels.  

The assembly script  1)  uses the xls file to make the Normal Condition 1 command and the Always on command for each device, 2) makes the console commons portion for each console and 3) copies the copy range from each console's file into the single MegaMaster dmx file.  

When using only the base game, this assembled file should be placed in ProgramFiles/Artemis/dat and named DMXcommands.xml.  
However, we wanted to use the extra DMX commands available from the ArtemisBridgeTools mod.  When using this, the file needs to be placed in C:\Users\Artemis\AppData\Local\ArtemisBridgeTools (with any name) and the file must be selected as the active profile in the ArtemisDmxEditor GUI, and the ArtemisDmxEditor mod needs to be linked to the Artemis exe location.   The ArtemisDmxEditor is an excellent testing and trouble shooting tool.  The editing ability is also very nice (not everyone likes to make scripts to make xml files).  My compliments to its author.  I just wish it was more robust in response to version changes from the game.

The commands that made me think of the mod as essential were the warp drive (1-4) commands—We have plans for building a warp core.  In the xls file, in the sheet “Event Responses”, you can see a list of all the commands we use (if there is a console and description listed, or planned to use in the near future if there is a ? in the Console column). The base/mod column indicates which commands are from the base (Artemis game) or the mod (ArtemisBridgeTools).  

Our hardware also mandated using the mod.  For reasons I don't fully understand, two of our five dmx boards only support dmxpro (they are a different style and brand than the other three).  The mod allows for dmxopen or dmxpro.  We didn't expect this limitation, and we may yet find a work-around, but for now, the solution is to use dmxpro across all boards.  This was just one more wrench in the works when we tried to make our system work with the newest release of the game.
