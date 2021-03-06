import System.IO
import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Warp
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.TwoPanePersistent (TwoPanePersistent (..))
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
-- module imports and other top level definitions

appManagedHook = composeAll
   [ className =? "zoom" --> doShift "zoom"
   ]

rebindings = [
    ("M-<Return>", spawn "alacritty")
  , ("M-`", spawn "dunstctl set-paused toggle")
    -- ("<Pause>", spawn "/home/zarkone/.config/fish/coding-music-toggle.fish"),
  , ("<Pause>", spawn "mpc toggle")
  -- , ("<XF86AudioPause>", spawn "mpc pause")
  -- , ("<XF86AudioPlay>", spawn "mpc play")
  , ("M-m", spawn "alacritty -e ncmpcpp")
  , ("M-C-h", spawn "alacritty -e htop")
  , ("<Print>", spawn "maim -s ~/maim/$(date +'%s-%d-%m-%y_%H:%M:%S').png")
  , ("M-C-l", spawn "slock")
  , ("M-t", spawn "alacritty -e bash -c 'xclip -selection c -o | xargs trans | less -r'")
  , ("M-C-p", spawn "systemctl suspend")
  , ("M-C-b", sendMessage ToggleStruts)
  , ("M-b", banishScreen LowerRight)
  , ("M-e", spawn "emacsclient -ca ''")
  , ("M-w", spawn "firefox")
  , ("M-u", spawn "pavucontrol")
  , ("M-y", spawn "blueman-manager")
  , ("M-p", spawn "rofi -show run")
  , ("M-o", spawn "rofi -combi-modi window,drun -show combi -modi combi")
  , ("M-a", viewScreen def 0)
  , ("M-s", viewScreen def 1)
  , ("M-S-a", sendToScreen def 0)
  , ("M-S-s", sendToScreen def 1)
  , ("<XF86Eject>", spawn "mv /home/zarkone/Maildir/Gmail/INBOX/new/* /home/zarkone/Maildir/Gmail/INBOX/cur/; mv /home/zarkone/Maildir/Xapix/INBOX/new/* /home/zarkone/Maildir/Xapix/INBOX/cur/")
  , ("<XF86AudioRaiseVolume>", spawn "pamixer -i 10")
  , ("<XF86AudioLowerVolume>", spawn "pamixer -d 10")
  , ("<XF86AudioMute>", spawn "pamixer -t")
  , ("C-<XF86AudioRaiseVolume>", spawn "xrandr --output HDMI-1 --brightness 1")
  , ("C-<XF86AudioLowerVolume>", spawn "xrandr --output HDMI-1 --brightness 0.5")
  ]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $
    ewmh
      defaultConfig
        { modMask = mod4Mask,
          normalBorderColor = "#221122",
          focusedBorderColor = "#664466",
          terminal = "alacritty",
          workspaces = ["code","www","term","work","chat","zoom","etc","mus","video"],
          manageHook = appManagedHook <+> manageDocks <+> manageHook defaultConfig,
          layoutHook = avoidStruts $ smartBorders $ Full ||| TwoPanePersistent Nothing (3 / 100) (1 / 2),
          -- this must be in this order, docksEventHook must be last
          handleEventHook = handleEventHook defaultConfig <+> docksEventHook,
          logHook =
            dynamicLogWithPP
              xmobarPP
                { ppOutput = hPutStrLn xmproc,
                  ppTitle = xmobarColor "magenta" "" . shorten 20,
                  ppCurrent = xmobarColor "yellow" "",
                  ppHiddenNoWindows = xmobarColor "#333333" ""
                }
        }
      `additionalKeysP` rebindings
