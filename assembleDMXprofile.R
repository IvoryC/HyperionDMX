# Compile the separate components of the DMX profile for Artemis
# Ivory Blakley
# 7 Apirl 2016


# packages - to download and install, uncomment these lines.
# The last line should automatically include the dependencies in the first two lines.
# install.packages("rjava")
# install.packages("xlsxjars")
# install.packages("xlsx")

# get the header
header = readLines("DMXcommands-HeaderAndDefaults.xml")
g = grep("DMX_CONTROL", header)
footer=header[g][2]
header=header[1:g[1]]

# read in the spread sheet to set up the DMX devices and defaults.
library(xlsx)
dmx = read.xlsx("DMX_Lights_ID_list.xls", sheetIndex = 1)
softID = names(dmx)[grep("DMX.soft",names(dmx))]

# Make the DMX devices list
g=which(!is.na(dmx$description))
devices = paste0("<!--",
                 dmx[g,softID]," ",
                 dmx[g,"color"]," value of ",
                 dmx[g,"description"], 
                 " -->")
devices = c("<!--  DMX ID MAP -->", devices)

# Set the always on settings
g=which(!is.na(dmx$AlwaysOn))
alwaysOn = paste0('<setvalue index="',dmx[g,softID],
                  '" value="', dmx[g,"AlwaysOn"],'"  change="0"/>','\t',
                  '<!-- ',dmx[g,"color"],' - ', dmx[g,"description"],' -->')

alwaysOn=c('<event type="ALWAYS_ON" continuous="yes">',
           '<!-- if the system is on, use these defaults for all things -->',
           '<timeblock mseconds="4000">',
           alwaysOn,
           '</timeblock>',
           '</event>')


# set the normal condition 1 settings
g=which(!is.na(dmx$NormalCondition1))
nc1 = paste0('<setvalue index="',dmx[g,grep("DMX.soft",names(dmx))],
             '" value="', dmx[g,"NormalCondition1"],'"  change="0"/>','\t',
             '<!-- ',dmx[g,"color"],' - ', dmx[g,"description"],' -->')

nc1=c('<event type="NORMAL_CONDITION_1" continuous="yes">',
      '<!-- if the system is on, use these defaults for all things -->',
      '<timeblock mseconds="4000">',
      nc1,
      '</timeblock>',
      '</event>')


# Read in the ConsoleCommons, which is a template profile for how to 
# treat the ship status box on all stations.
common = readLines("DMXcommands-ConsoleCommons.xml")
start = grep("Start copy range", common)+2
end = grep("End copy range",common)-2
common = common[start:end]
# for this, we will need the section of the dmx id list that applies to each console
DMX = split(dmx, f=dmx$Console)


# Read in the profile for each console
# note: the order of the standard consoles does not matter, 
# but Ambiance should be last so ship-wide events trump all.
consoles = c("Communications", "Engineering", "Helm", "Science", "Weapons", "Ambiance", "WarpCore")
consoleFiles = paste0("DMXcommands-", consoles, ".xml")
separator = paste0("<!-- ", paste(rep("*", 100), collapse=""), " -->")
allConsoles = ""

for (i in 1:length(consoles))
{
  #convert the ConsoleCommons lines to fit this station
  commonLines=common
  convertFrom = paste0('index="',DMX[[consoles[i]]][,"withinConsoleID"],'"')
  convertTo = paste0('index="',DMX[[consoles[i]]][,softID],'"')
  for (j in 1:nrow(DMX[[consoles[i]]])){
    commonLines = gsub(convertFrom[j],convertTo[j],commonLines)
  }
  
  #get the lines specific to each file
  lines = readLines(consoleFiles[i])
  start = grep("Start copy range", lines)+2
  end = grep("End copy range",lines)-2
  lines = lines[start:end]
  
  # Combine all for this console
  allConsoles = c(allConsoles, "",
                  separator, paste0("<!-- ", consoles[i], " -->"), separator,
                  "", commonLines, "",
                  "", lines, "")
}


# Now that all the data is read in, its time to write it out to one new file
outFile = "DMXcommands-MegaMaster.xml"


allDMX=c(header, "", "", 
         separator, paste0("<!-- ", "Devices", " -->"), separator,
         "", devices, "", "", 
         separator, paste0("<!-- ", "Always On", " -->"), separator,
         "", alwaysOn, "", "", 
         separator, paste0("<!-- ", "Normal Condition 1", " -->"), separator,
         "",nc1, "", "",
         allConsoles, "", "",
         footer)

writeLines(allDMX, outFile)





