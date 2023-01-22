import {useCallback, useEffect} from "preact/hooks"

export const useHotkey = (hotkey: string, action: () => void) => {
  const onKeyDown = useCallback(
    ({metaKey, ctrlKey, key}: KeyboardEvent) => {
      if ((metaKey || ctrlKey) && key.toLowerCase() == hotkey) {
        action()
      }
    },
    [action, hotkey]
  )

  useEffect(() => {
    document.addEventListener("keydown", onKeyDown)

    return () => document.removeEventListener("keydown", onKeyDown)
  }, [onKeyDown])
}
