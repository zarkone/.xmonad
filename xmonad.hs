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
import qualified XMonad.StackSet as W

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
-- module imports and other top level definitions

myWorkspaces = ["!","@","#","$","%","^","&","*","("]
zoomWorkspace = myWorkspaces !! 5

term = "alacritty"
wrapWithTerm x = term ++ " -e " ++ x

appManagedHook = composeAll
   [ className =? "zoom" --> doShift zoomWorkspace]

screenshot = "maim -s ~/maim/$(date +'%s-%d-%m-%y_%H:%M:%S').png"

clearUnreadMail =
  "mv /home/zarkone/Maildir/Gmail/INBOX/new/* /home/zarkone/Maildir/Gmail/INBOX/cur/;"
  ++ "mv /home/zarkone/Maildir/Pitch/INBOX/new/* /home/zarkone/Maildir/Pitch/INBOX/cur/"

rebindings = [
  ("M-<Return>", spawn term)
  , ("M-<Backspace>", spawn "dunstctl close-all")
  , ("M-]", spawn "dunstctl history-pop")
  , ("M-`", spawn "dunstctl set-paused toggle")
    -- ,  ("<Pause>", spawn "/home/zarkone/.config/fish/coding-music-toggle.fish")
  , ("<Pause>", spawn "mpc toggle")
  , ("M-<Right>", spawn "mpc next")
  , ("M-<Left>", spawn "mpc prev")
    -- , ("<XF86AudioPause>", spawn "mpc pause")
    -- , ("<XF86AudioPlay>", spawn "mpc play")
  , ("<Print>", spawn screenshot)
  , ("M-C-l", spawn "betterlockscreen --lock --off 10 --time-format '%H:%M'")
  , ("M-C-p", spawn "systemctl suspend")
  , ("M-C-b", sendMessage ToggleStruts)
  -- apps
  , ("M-x m", spawn $ wrapWithTerm "ncmpcpp")
  , ("M-x z", spawn $ wrapWithTerm "htop")
  , ("M-x f", spawn $ wrapWithTerm "ranger")
  , ("M-x t", spawn $ wrapWithTerm "bash -c 'xclip -selection c -o | xargs trans | less -r'")
  , ("M-x b", banishScreen LowerRight)
  , ("M-x e", spawn $ wrapWithTerm "emacsclient -nw -a ''")
  , ("M-x w", spawn "firefox")
  , ("M-x u", spawn "pavucontrol")
  , ("M-x p", spawn "rofi -location 2 -show run ")
  , ("M-x o", spawn "rofi -location 2 -combi-modi window,drun -show combi -modi combi")
  , ("M-x y", spawn "blueman-manager")
  , ("M-x W", spawn "google-chrome-beta")
  -- windows
  , ("M-y", windows $ W.greedyView "!")
  , ("M-u", windows $ W.greedyView "@")
  , ("M-i", windows $ W.greedyView "#")
  , ("M-h", windows $ W.greedyView "$")
  , ("M-j", windows $ W.greedyView "%")
  , ("M-k", windows $ W.greedyView "^")
  , ("M-n", windows $ W.greedyView "&")
  , ("M-m", windows $ W.greedyView "*")
  , ("M-,", windows $ W.greedyView "(")

  -- multimonitor
  , ("M-a", viewScreen def 0)
  , ("M-s", viewScreen def 1)
  , ("M-S-a", sendToScreen def 0)
  , ("M-S-s", sendToScreen def 1)
  , ("<XF86Eject>", spawn clearUnreadMail)
  , ("<XF86AudioRaiseVolume>", spawn "pamixer -i 5")
  , ("<XF86AudioLowerVolume>", spawn "pamixer -d 5")
  , ("<XF86AudioMute>", spawn "pamixer -t")
  ]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $
    ewmh
    defaultConfig
    { modMask = mod4Mask
    , normalBorderColor = "#212"
    , focusedBorderColor = "purple"
    , terminal = "alacritty"
    , workspaces = myWorkspaces
    , manageHook = appManagedHook <+> manageDocks <+> manageHook defaultConfig
      -- layoutHook = avoidStruts  $ layoutHook defaultConfig,
    , layoutHook = avoidStruts $ smartBorders $ Full ||| Mirror (TwoPanePersistent Nothing (3 / 100) (3 / 5))
      -- layoutHook = avoidStruts $ smartBorders $ Full ||| TwoPanePersistent Nothing (3 / 100) (1 / 2),
      -- layoutHook = avoidStruts $ smartBorders $ Full ||| Mirror (Tall 2 (3/100) (4/5)),
      -- this must be in this order, docksEventHook must be last
    , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
    , logHook =
        dynamicLogWithPP
        xmobarPP
        { ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor "magenta" "" . shorten 30
        , ppCurrent = xmobarColor "#212" "#f0f" . wrap " " " "
        , ppHidden = xmobarColor "cyan" "#212"
        , ppHiddenNoWindows = xmobarColor "#777" ""
        }
    }
    `additionalKeysP` rebindings
