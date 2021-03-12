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
           , Run Mail [("<fc=yellow><icon=/home/zarkone/.xmonad/xbm/mail.xbm/></fc> ", "~/Maildir/Gmail/INBOX"),
                       ("<fc=green><icon=/home/zarkone/.xmonad/xbm/mail.xbm/></fc> ", "~/Maildir/Xapix/INBOX")]
             "mail"
           , Run Kbd [("ru", "<fc=#212,yellow> ru </fc>"), ("us", " us ")]
           , Run Date "%d/%m[%a]" "date" 10
           , Run Date "%H:%M" "time" 10
           , Run Memory ["-t","<usedratio>%"] 10
           , Run Com "/home/zarkone/.xmonad/disk.fish" ["home"] "diskhome" 1800
           , Run Com "/home/zarkone/.xmonad/disk.fish" ["nixos"] "disknixos" 1800
           , Run Com "/home/zarkone/.xmonad/dunstdnd.fish" [] "dusntdnd" 10
           ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% :: %kbd% }{ %mail% <fc=#800080> %disknixos% %diskhome% </fc><icon=/home/zarkone/.xmonad/xbm/memory.xbm/> %memory%<fc=green> %date% </fc><fc=yellow>%time%</fc> %dusntdnd%"
       }
