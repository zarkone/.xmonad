import XMonad
import XMonad.Actions.Warp
import XMonad.Layout
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.TwoPane (TwoPane(..))
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.PhysicalScreens
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ ewmh defaultConfig
      { modMask            = mod4Mask
      , normalBorderColor = "#221122"
      , focusedBorderColor = "#664466"
      , terminal           = "alacritty"
      , manageHook         = manageDocks <+> manageHook defaultConfig
      , layoutHook         = avoidStruts $ smartBorders $ Full ||| TwoPane (3/100) (1/2)
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook defaultConfig <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle           = xmobarColor "magenta"  "" . shorten 20
          , ppCurrent = xmobarColor "yellow" ""
          , ppHiddenNoWindows = xmobarColor "#333333" ""
          }
      } `additionalKeysP`
      [
        ("M-<Return>", spawn "alacritty")
      , ("M-C-b", sendMessage ToggleStruts)
      , ("M-b", banishScreen LowerRight)
      , ("M-e", spawn "emacsclient -ca ''")
      , ("M-w", spawn "firefox")
      , ("M-C-w", spawn "vimb")
      , ("M-p", spawn "rofi -show run")
      , ("M-a", viewScreen def 0)
      , ("M-s", viewScreen def 1)
      , ("M-S-a", sendToScreen def 0)
      , ("M-S-s", sendToScreen def 1)
      , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
      , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -5%")
      , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
      , ("<XF86MonBrightnessUp>", spawn "light -A 10")
      , ("<XF86MonBrightnessDown>", spawn "light -U 10")
      , ("C-<XF86AudioRaiseVolume>", spawn "light -A 10")
      , ("C-<XF86AudioLowerVolume>", spawn "light -U 10")

      ]
