
library(xlsx)
lights = read.xlsx2("DMX_Lights_ID_list.xls",1)
lights$withinConsoleID = as.numeric(as.character(lights$withinConsoleID))
lights$withinConsoleX = as.numeric(as.character(lights$withinConsoleX))
lights$withinConsoleY = as.numeric(as.character(lights$withinConsoleY))

### ID	Model	Mode	Universe	Address	Group
# make an ID that lightjams will accept.
# no more than 4 characters, all caps, no numbers.
# Use the first two letters from the console name, 
# and make the last letter indicate the color.
# The one character in between just has to distinguish the 
# lights that are the same color and on the same console.
lights$ID = paste0(toupper(substr(lights$Console,1,2)), 
                   LETTERS,
                   toupper(substr(lights$color,1,1)))
lights$Model = "Hyperion single"
lights$Mode = "Mode 1 (1ch.)"
lights$Universe = "USB-Open"
lights$Address = lights$DMX.board.1.based.
lights$Group = lights$Console

# leave out the red and green channel for the ship status, keep blue
lights$withinConsoleX[lights$withinConsoleID %in% c(1,3,4,5,7,9)] = NA
lights$withinConsoleX[lights$withinConsoleX==""] = NA

consoles = lights[!is.na(lights$withinConsoleX), ]


########
# This section is from when I was writing fixtures to an html file
########
#
#warpCore = lights[lights$Console=="WarpCore", ]
#fixtures = rbind(warpCore, consoles)
# fixtures = consoles
# 
# 
# fixtures = fixtures[,c("ID",	"Model",	"Mode",	"Universe",	"Address",	"Group")]
# fixtureRows = apply(fixtures, 1, paste, collapse="</td><td>")
# fixtureRows = paste0("<td>", fixtureRows, "</td>")
# fixtureRows = paste(fixtureRows, collapse="</tr><tr>")
# 
# 
# headerP1 = '<html><head><meta http-equiv=Content-Type content="text/html; charset=UTF-8" /></head><body><p>Lightjams patch exported on'
# daytime = date()
# headerMiddle = '</p><p>'
# numberOfFixtures = nrow(warpCore) + nrow(hasXY)
# headerP2 = ' fixtures.</p><p>&nbsp;</p><table style="text-align: center"><tr><th>ID</th><th>Model</th><th>Mode</th><th>Universe</th><th>Address</th><th>Group</th></tr><tr>'
# 
# header = paste0(headerP1, daytime, headerMiddle, numberOfFixtures, headerP2)
# footer = '</tr></table></body></html>'
# 
# allText = paste0(c(header,
#                    fixtureRows,
#                    footer, collapse = ""))
# outfile = "HyperionFixturesFile.html"
# writeLines(allText, con=outfile, sep="")


# ###### write fixtures section of light jams project file

### output should match this:

# <fixture>
#   <id>RGB</id>
#   <manufacturer>Generic</manufacturer>
#   <name>RGB-RAW</name>
#   <templateId>616f91f5-8d43-43a5-9cab-15879b45bb9b</templateId>
#   <mode>320aa107-c189-4379-9ef8-6bb679c66405</mode>
#   <modeName>Mode 1</modeName>
#   <dmxAddress>1</dmxAddress>
#   <position>18</position>
#   <group>Example</group>
#   </fixture>
#   
#   <fixture>
#   <id>DIM</id>
#   <manufacturer>Generic</manufacturer>
#   <name>Dimmer</name>
#   <templateId>34ac5e5a-a771-4b2e-9e2b-8cb835024b20</templateId>
#   <mode>55e4a7f7-c35e-483a-b79a-6a98f2b33ad8</mode>
#   <modeName>8 bits</modeName>
#   <dmxAddress>0</dmxAddress>
#   <position>1</position>
#   <group>Example</group>
#   </fixture>
  
  
  # for now, just treat everything as a simple dimmer
  
  openString = "<fixture>\n<id>"
fixType = c("</id>\n<manufacturer>Generic</manufacturer>\n<name>RGB-RAW</name>\n<templateId>616f91f5-8d43-43a5-9cab-15879b45bb9b</templateId>\n<mode>320aa107-c189-4379-9ef8-6bb679c66405</mode>\n<modeName>Mode 1</modeName>\n<dmxAddress>",
            "</id>\n<manufacturer>Generic</manufacturer>\n<name>Dimmer</name>\n<templateId>34ac5e5a-a771-4b2e-9e2b-8cb835024b20</templateId>\n<mode>55e4a7f7-c35e-483a-b79a-6a98f2b33ad8</mode>\n<modeName>8 bits</modeName>\n<dmxAddress>")
names(fixType) = c("tricolor strip", "single")
midString1 = "</dmxAddress>\n<position>"
midString2 = "</position>\n<group>"
closeString = "</group>\n</fixture>"

fixtureStrings = paste0(openString, 
                        consoles$ID, 
                        fixType["single"],
                        consoles$Address,
                        midString1,
                        consoles$withinConsoleID,
                        midString2,
                        consoles$Group,
                        closeString)

projectFixtures = "LightJams/fixturesForProjectFile.txt"
writeLines(fixtureStrings, con=projectFixtures)

#### write to the receptor section
### output should match this:
# <receptor>
#   <x>7</x>
#   <y>7</y>
#   <fixtureId>RGB</fixtureId>
#   <attributeId>cap1.dimmer</attributeId>
#   </receptor>
  # <receptor>
  # <x>7</x>
  # <y>9</y>
  # <fixtureId>DIM</fixtureId>
  # <attributeId>dimmer</attributeId>
  # </receptor>

recOpenString = "<receptor>\n<x>"
mid1String = "</x>\n<y>"
mid2String = "</y>\n<fixtureId>"
recCloseString = "</fixtureId>\n<attributeId>dimmer</attributeId>\n</receptor>"

consoles$withinConsoleX = as.numeric(as.character(consoles$withinConsoleX))
consoles$withinConsoleY = as.numeric(as.character(consoles$withinConsoleY))

consoleOrder = c(0,1,2,3,4)
names(consoleOrder) = c("Engineering", "Weapons", "Helm", "Science", "Communications")
consoles$Xshift = 50 * consoleOrder[as.character(consoles$Console)]
consoles$absX = consoles$withinConsoleX + consoles$Xshift

consoles$lightJamsX = floor(consoles$absX / 2)
consoles$lightJamsY = floor(consoles$withinConsoleY / 2)

receptorStrings = paste0(recOpenString,
                         consoles$lightJamsX,
                         mid1String,
                         consoles$lightJamsY,
                         mid2String,
                         consoles$ID,
                         recCloseString)

projectReceptors = "LightJams/receptorsForProjectFile.txt"
writeLines(receptorStrings, con=projectReceptors)

###

