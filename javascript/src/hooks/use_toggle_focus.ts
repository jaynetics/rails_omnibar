import {useCallback} from "preact/hooks"
import {INPUT_DATA_ID} from "../types"

export const useToggleFocus = () => {
  return useCallback(() => {
    setTimeout(() => {
      const input = document.querySelector<HTMLInputElement>(`[data-id=${INPUT_DATA_ID}]`)
      if (document.activeElement === input) {
        input?.blur()
      } else {
        input?.focus()
      }
    }, 100)
  }, [])
}
