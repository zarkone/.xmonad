import System.IO
import XMonad
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Warp
import XMonad.Actions.CopyWindow
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.TwoPanePersistent (TwoPanePersistent (..))
import XMonad.Util.Cursor
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (spawnPipe)
import qualified XMonad.StackSet as W

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig
import qualified XMonad.Util.ExtensibleState as XS
import qualified Data.Map as Map
-- module imports and other top level definitions

myWorkspaces = ["!","@","#","$","%","^","&","*","("]
zoomWorkspace = myWorkspaces !! 5

term = "alacritty"
wrapWithTerm cmd = term ++ " -e " ++ cmd
wrapWithLess cmd = "bash -c '" ++ cmd ++ " 2>/dev/null | less -R'"

rotateDisplayCmd direction = "xrandr --output HDMI-A-0 --mode 2560x1440 --rate 75 --rotate " ++ direction ++ " --dpi 110 && feh --bg-center ~/pics/eva4.jpg"

newtype IsRightDisplayRotation = IsRightDisplayRotation { getIsRightDisplayRotation :: Bool }
  deriving (Show)
instance ExtensionClass IsRightDisplayRotation where
  initialValue = IsRightDisplayRotation False

-- toggleDisplayOrientation :: X ()
-- toggleDisplayOrientation = do
--   IsRightDisplayRotation r <- IsRightDisplayRotation . liftX $ XS.get
--   spawn $ wrapWithTerm $ rotateDisplayCmd $ if r then "right" else "normal"


appManagedHook = composeAll
   [ className =? "zoom" --> doShift zoomWorkspace]

screenshot = "maim -s ~/maim/$(date +'%s-%d-%m-%y_%H:%M:%S').png"

clearUnreadMail =
  "mv /home/zarkone/Maildir/Gmail/INBOX/new/* /home/zarkone/Maildir/Gmail/INBOX/cur/;"
  ++ "mv /home/zarkone/Maildir/Pitch/INBOX/new/* /home/zarkone/Maildir/Pitch/INBOX/cur/"

rebindings = [
  ("M-=", spawn term)
  , ("M-<Backspace>", spawn "dunstctl close-all")
  , ("M-]", spawn "dunstctl history-pop")
  , ("M-`", spawn "dunstctl set-paused toggle")
    -- ,  ("<Pause>", spawn "/home/zarkone/.config/fish/coding-music-toggle.fish")
  , ("<Pause>", spawn "mpc toggle")
  , ("M-<Right>", spawn "mpc next")
  , ("M-<Left>", spawn "mpc prev")
  , ("<Print>", spawn screenshot)
  , ("M-C-l", spawn "betterlockscreen --lock --off 10 --time-format '%H:%M'")
  , ("M-C-p", spawn "systemctl suspend")
  , ("M-C-b", sendMessage ToggleStruts)
  , ("M-C-d", spawn $ wrapWithTerm $ rotateDisplayCmd "left")
  , ("M-C-c", spawn $ wrapWithTerm $ rotateDisplayCmd "normal")
  , ("M-q", kill)
  , ("M-S-q", spawn "xmonad --recompile && xmonad --restart")

  -- apps
  , ("M-c", spawn $ wrapWithTerm $ wrapWithLess "curl wttr.in")
  , ("M-.", spawn $ wrapWithTerm $ wrapWithLess "xclip -selection c -o | xargs trans")
  , ("M-m", spawn $ wrapWithTerm "ncmpcpp")
  , ("M-z", spawn $ wrapWithTerm "gotop")
  , ("M-x", banishScreen LowerRight)
  , ("M-f", spawn "emacsclient -c -a ''")
  , ("M-w", spawn "firefox")
  , ("M-S-w", spawn "google-chrome-beta  --profile-directory='Profile 3' --new-window 'http://localhost:9666'")
  , ("M-M1-w", spawn "firefox --new-window 'https://duckduckgo.com/'")
  , ("M-u", spawn $ wrapWithTerm "pulsemixer")
  , ("M-'", spawn "rofi -location 2 -show run ")
  , ("M-\\", spawn "rofi -location 2 -combi-modi window,drun -show combi -modi combi")
  , ("M-y", spawn "blueman-manager")
  , ("M-W", spawn "google-chrome-beta")
  -- windows
  , ("M-a", windows $ W.greedyView "!")
  , ("M-r", windows $ W.greedyView "@")
  , ("M-s", windows $ W.greedyView "#")
  , ("M-t", windows $ W.greedyView "$")
  , ("M-d", windows $ W.greedyView "%")
  , ("M-g", windows $ W.greedyView "^")
  , ("M-p", windows $ W.greedyView "&")
  , ("M-b", windows $ W.greedyView "*")
  , ("M-v", windows $ W.greedyView "(")

  , ("M-M1-a", windows $ W.shift "!")
  , ("M-M1-r", windows $ W.shift "@")
  , ("M-M1-s", windows $ W.shift "#")
  , ("M-M1-t", windows $ W.shift "$")
  , ("M-M1-d", windows $ W.shift "%")
  , ("M-M1-g", windows $ W.shift "^")
  , ("M-M1-p", windows $ W.shift "&")
  , ("M-M1-b", windows $ W.shift "*")
  , ("M-M1-v", windows $ W.shift "(")
  , ("M-M1-j", windows $ copyToAll)

  -- multimonitor
  -- , ("M-a", viewScreen def 0)
  -- , ("M-s", viewScreen def 1)
  -- , ("M-S-a", sendToScreen def 0)
  -- , ("M-S-s", sendToScreen def 1)
  , ("<XF86Eject>", spawn clearUnreadMail)
  , ("<XF86AudioRaiseVolume>", spawn "pamixer -i 5")
  , ("<XF86AudioLowerVolume>", spawn "pamixer -d 5")
  , ("<XF86AudioMute>", spawn "pamixer -t")
  ]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ docks $ ewmh
    def
    { modMask = mod4Mask
    , normalBorderColor = "#222"
    , focusedBorderColor = "purple"
    , terminal = "alacritty"
    , workspaces = myWorkspaces
    , startupHook = composeAll [ startupHook def
                               -- , spawn $ wrapWithTerm $ rotateDisplayCmd "left"
                               , setDefaultCursor xC_left_ptr
                               ]
    , manageHook = composeAll [ manageHook def
                              ,  appManagedHook
                              ]
      -- layoutHook = avoidStruts  $ layoutHook defaultConfig,
    -- , layoutHook = avoidStruts $ smartBorders $ Full ||| Mirror (TwoPanePersistent Nothing (3 / 100) (3 / 5))
    , layoutHook = avoidStruts $ smartBorders $ Full ||| TwoPanePersistent Nothing (3 / 100) (1 / 2)
    -- , layoutHook = avoidStruts $ smartBorders $ TwoPanePersistent Nothing (3 / 100) (1 / 2)
      -- layoutHook = avoidStruts $ smartBorders $ Full ||| Mirror (Tall 2 (3/100) (4/5)),
      -- this must be in this order, docksEventHook must be last
    , logHook =
        dynamicLogWithPP
        xmobarPP
        { ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor "magenta" "" . shorten 300
        , ppCurrent = xmobarColor "#111" "#f0f" . wrap " " " "
        , ppHidden = xmobarColor "cyan" "#111"
        , ppHiddenNoWindows = xmobarColor "#777" ""
        }
    }
    `additionalKeysP` rebindings
