Config { font = "xft:Fixed-12"
       , additionalFonts = []
       , borderColor = "black"
       , border = TopB
       , bgColor = "#221122"
       , fgColor = "cyan"
       , alpha = 255
       , position = Top
       , textOffset = -1
       , iconOffset = -1
       , lowerOnStart = True
       , pickBroadest = False
       , persistent = False
       , hideOnStart = False
       , iconRoot = "."
       , allDesktops = True
       , overrideRedirect = True
       , commands = [
           Run StdinReader
           , Run Date "%b %d (%a) %H:%M" "date" 10
           , Run Battery [ "--template" , "<acstatus>"
                         , "--Low"      , "10"        -- units: %
                         , "--High"     , "80"        -- units: %
                         , "--low"      , "darkred"
                         , "--normal"   , "darkorange"
                         , "--high"     , "darkgreen"

                         , "--" -- battery specific options
                           -- discharging status
                         , "-o"	, "<left>% (<timeleft>)"
                           -- AC "on" status
                         , "-O"	, "<fc=#dAA520>Charging</fc>"
                           -- charged status
                         , "-i"	, "<fc=#006000>Charged</fc>"
                         ] 50
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% }{ %battery% <fc=green>%date%</fc> "
       }
