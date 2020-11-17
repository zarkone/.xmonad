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
           -- , Run Mail [("Gmail: ", "~/Maildir/Gmail/INBOX"), ("Xapix", "~/Maildir/Xapix/INBOX")] "mail"
           , Run Mail [("ZS:", "~/Maildir/Gmail/INBOX"), ("XX:", "~/Maildir/Xapix/INBOX")] "mail"
           , Run Kbd [("ru", "<fc=#212,yellow> ru </fc>"), ("us", " us ")]
           , Run Date "%d.%m:%a" "date" 10
           , Run Date "%H:%M" "time" 10
           , Run Memory ["-t","<usedratio>%"] 10
           , Run Com "/home/zarkone/.xmonad/disk-home.fish" ["home"] "diskhome" 1800
           ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% :: %kbd% }{ <fc=#434><icon=/home/zarkone/.xmonad/xbm/filesystem.xbm/> %diskhome% </fc><fc=yellow><icon=/home/zarkone/.xmonad/xbm/mail.xbm/></fc> %mail% <fc=yellow><icon=/home/zarkone/.xmonad/xbm/memory.xbm/></fc> %memory% <fc=#434>%date%</fc> <fc=green>%time%</fc> "
       }
