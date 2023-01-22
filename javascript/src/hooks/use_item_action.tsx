import React, {useCallback} from "preact/hooks"
import {Item, ModalBag} from "../types"

export const useItemAction = (modal: ModalBag) => {
  return useCallback(
    (item: Item) => {
      if (!item) return

      item = item as Item
      if (item.url) {
        window.location.href = item.url
      } else if (item.modalHTML) {
        const __html = item.modalHTML
        modal.setBody(<div dangerouslySetInnerHTML={{__html}} />)
        modal.toggle()
      }
    },
    [modal]
  )
}
