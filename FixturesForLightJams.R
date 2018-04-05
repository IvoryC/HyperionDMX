
library(xlsx)
lights = read.xlsx2("DMX_Lights_ID_list.xls",1)
lights$withinConsoleID = as.numeric(as.character(lights$withinConsoleID))


### ID	Model	Mode	Universe	Address	Group
# make an ID that lightjams will accept.
# no more than 4 characters, all caps, no numbers.
# Use the first two letters from the console name, 
# and make the last letter indicate the color.
# The one character in between just has to distinguish the 
# lights that are the same color and on the same console.
lights$ID = paste0(toupper(substr(lights$Console,1,2)), 
                   LETTERS[8:17],
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

#warpCore = lights[lights$Console=="WarpCore", ]
#fixtures = rbind(warpCore, consoles)
fixtures = consoles
fixtures = fixtures[,c("ID",	"Model",	"Mode",	"Universe",	"Address",	"Group")]
fixtureRows = apply(fixtures, 1, paste, collapse="</td><td>")
fixtureRows = paste0("<td>", fixtureRows, "</td>")
fixtureRows = paste(fixtureRows, collapse="</tr><tr>")


headerP1 = '<html><head><meta http-equiv=Content-Type content="text/html; charset=UTF-8" /></head><body><p>Lightjams patch exported on'
daytime = date()
headerMiddle = '</p><p>'
numberOfFixtures = nrow(warpCore) + nrow(hasXY)
headerP2 = ' fixtures.</p><p>&nbsp;</p><table style="text-align: center"><tr><th>ID</th><th>Model</th><th>Mode</th><th>Universe</th><th>Address</th><th>Group</th></tr><tr>'

header = paste0(headerP1, daytime, headerMiddle, numberOfFixtures, headerP2)
footer = '</tr></table></body></html>'

allText = paste0(c(header,
                   fixtureRows,
                   footer, collapse = ""))
outfile = "HyperionFixturesFile.html"
writeLines(allText, con=outfile, sep="")

