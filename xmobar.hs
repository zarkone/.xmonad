Config { font = "xft:JetBrains Mono:size=12:antialias=true"
       , borderColor = "black"
       , border = TopB
       , bgColor = "#221122"
       , fgColor = "cyan"
       , alpha = 255
       , position = Top
       , textOffset = -1
       , iconOffset = -1
       , lowerOnStart = True
       , pickBroadest = True
       , persistent = True
       , hideOnStart = False
       , iconRoot = "."
       , allDesktops = True
       , overrideRedirect = True
       , commands = [
           Run StdinReader
           , Run Mail [("Gmail: ", "~/Maildir/Gmail/INBOX"), ("Xapix", "~/Maildir/Xapix/INBOX")] "mail"
           , Run Kbd [("ru", "ru"), ("us", "us")]
           , Run Date "%d.%m:%a" "date" 10
           , Run Date "%H:%M" "time" 10
           , Run Memory ["-t","M: <usedratio>%"] 10
           , Run Com "/home/zarkone/.xmonad/disk-home.fish" ["home"] "diskhome" 1800
           ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% [<fc=yellow>%kbd%</fc>] }{ %mail% <]<fc=#434>[%diskhome%][%date%]</fc> %memory% <fc=green>%time%</fc> "
       }
