import React, {useCallback, useMemo, useState} from "preact/hooks"
import ReactModal from "react-modal"
import {ModalBag} from "../types"

export const useModal = (staticBody?: JSX.Element): ModalBag => {
  const [open, setOpen] = useState(false)
  const [body, setBody] = useState(<></>)

  const modal = useMemo(
    () => (
      <ReactModal
        ariaHideApp={false}
        isOpen={open}
        onRequestClose={() => setOpen(false)}
        style={{overlay: {zIndex: 1001}, content: {zIndex: 1001}}}
      >
        <span
          onClick={() => setOpen(false)}
          style={{cursor: "pointer", float: "right"}}
        >
          ╳
        </span>
        <div style={{visibility: "hidden"}}>╳</div>
        {staticBody || body}
      </ReactModal>
    ),
    [body, open, setOpen, staticBody]
  )

  const toggle = useCallback(() => setOpen(!open), [setOpen, open])

  return {modal, setBody, toggle}
}
