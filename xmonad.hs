import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
    xmonad $ defaultConfig
      { modMask            = mod4Mask
      , terminal           = "urxvt"
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
      } `additionalKeys`
      [ ((mod4Mask, xK_b), sendMessage ToggleStruts) ]
