import {useCallback} from "preact/hooks"
import {INPUT_DATA_ID} from "../types"

export const useToggleFocus = () => {
  return useCallback(() => {
    setTimeout(() => {
      const input = document.querySelector(`[data-id=${INPUT_DATA_ID}]`)
      if (input && document.activeElement === input) {
        ;(input as HTMLInputElement).blur()
      } else if (input) {
        ;(input as HTMLInputElement).focus()
      }
    }, 100)
  }, [])
}
