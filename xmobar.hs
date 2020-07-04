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
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% }{ <fc=green>%date%</fc> "
       }
