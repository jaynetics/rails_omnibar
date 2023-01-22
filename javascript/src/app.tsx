import React, {FunctionComponent} from "preact"
import habitat from "preact-habitat"
import Omnibar from "omnibar2"
import {useItemAction, useOmnibarExtensions} from "./hooks"
import {useHotkey, useModal, useToggleFocus} from "./hooks"
import {AppArgs, INPUT_DATA_ID, Item, ModalArg} from "./types"

document.addEventListener("DOMContentLoaded", () => {
  habitat(App).render({selector: "#mount-rails-omnibar"})
})

const App: FunctionComponent<AppArgs> = (args) => {
  const itemModal = useModal()
  const toggleFocus = useToggleFocus()
  useHotkey(args.hotkey, toggleFocus)

  const Component = args.modal ? RailsOmnibarAsModal : RailsOmnibar
  return <Component {...args} itemModal={itemModal} />
}

const RailsOmnibar: FunctionComponent<AppArgs & ModalArg> = (args) => {
  const extensions = useOmnibarExtensions(args)
  const itemAction = useItemAction(args.itemModal)

  return (
    <>
      <Omnibar<Item>
        data-id={INPUT_DATA_ID}
        extensions={extensions}
        maxResults={args.maxResults}
        onAction={itemAction}
        placeholder={args.placeholder}
      />
      {args.itemModal.modal}
    </>
  )
}

const RailsOmnibarAsModal: FunctionComponent<AppArgs & ModalArg> = (args) => {
  const {modal, toggle} = useModal(<RailsOmnibar {...args} />)
  useHotkey(args.hotkey, toggle)

  return modal
}
