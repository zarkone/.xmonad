import XMonad
import XMonad.Actions.Warp
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ defaultConfig
      { modMask            = mod4Mask
      , normalBorderColor = "#221122"
      , focusedBorderColor = "#664466"
      , terminal           = "alacritty"
      , manageHook         = manageDocks <+> manageHook defaultConfig
      , layoutHook         = avoidStruts  $ layoutHook defaultConfig
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
      , ("M-w", spawn "google-chrome-stable")
      , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
      , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
      , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
      , ("<XF86MonBrightnessUp>", spawn "light -A 20")
      , ("<XF86MonBrightnessDown>", spawn "light -U 20")
      , ("C-<XF86AudioRaiseVolume>", spawn "light -A 20")
      , ("C-<XF86AudioLowerVolume>", spawn "light -U 20")

      ]
