import {useCallback, useEffect} from "preact/hooks"

export const useHotkey = (hotkey: string, action: () => void) => {
  const onKeyDown = useCallback(
    (e: KeyboardEvent) => {
      const {metaKey, ctrlKey, key} = e
      if ((metaKey || ctrlKey) && key.toLowerCase() == hotkey) {
        e.preventDefault()
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
