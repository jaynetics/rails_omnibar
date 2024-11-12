import {useEffect, useRef, useState} from "preact/hooks"

export const useDelayedLoadingStyle = () => {
  const [enabled, setEnabled] = useState(false)
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null)
  const clear = () => {
    timer.current && clearTimeout(timer.current)
    timer.current = null
  }

  const startTimer = () => {
    clear()
    timer.current = setTimeout(() => setEnabled(true), 100)
  }

  const stop = () => {
    clear()
    setEnabled(false)
  }

  useEffect(() => () => { clear() }, [])

  return { style : enabled ? LOADING_STYLE : {}, startTimer, stop }
}

const LOADING_STYLE = {
  background: "repeating-linear-gradient(45deg, #000F, #000D 30%, #0003 50%, #000D 70%, #000F)",
  backgroundClip: "text",
  backgroundPosition: "40000px",
  color: "#0001",
  transition: "background 100s ease-out, color 0.15s ease-in",
}
