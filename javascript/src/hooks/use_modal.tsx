import React, {useCallback, useMemo, useState} from "preact/hooks"
import ReactModal from "react-modal"
import {ModalBag} from "../types"

export const useModal = (staticBody?: JSX.Element, padding = 20): ModalBag => {
  const [open, setOpen] = useState(false)
  const [body, setBody] = useState(<></>)

  const modal = useMemo(
    () => (
      <ReactModal
        ariaHideApp={false}
        isOpen={open}
        onRequestClose={() => setOpen(false)}
        style={STYLE}
      >
        <span
          onClick={() => setOpen(false)}
          style={{
            cursor: "pointer",
            position: "absolute",
            top: 7,
            right: 9,
            zIndex: CONTENT_STYLE.zIndex + 1,
          }}
        >
          ╳
        </span>
        <div style={{padding}}>{staticBody || body}</div>
      </ReactModal>
    ),
    [body, open, setOpen, staticBody]
  )

  const toggle = useCallback(() => setOpen(!open), [setOpen, open])

  return {modal, setBody, toggle}
}

const OVERLAY_STYLE = {zIndex: 1001}
const CONTENT_STYLE = {
  ...OVERLAY_STYLE,
  maxWidth: 640,
  maxHeight: 640,
  margin: "auto",
  padding: "2px 0 2px 0",
}
const STYLE = {
  overlay: OVERLAY_STYLE,
  content: CONTENT_STYLE,
}
