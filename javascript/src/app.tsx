import React, {FunctionComponent, render} from "preact"
import Omnibar, {buildItemStyle} from "omnibar2"
import {Globals} from "csstype"
import {
  useDelayedLoadingStyle,
  useItemAction,
  useOmnibarExtensions,
} from "./hooks"
import {useHotkey, useModal, useToggleFocus} from "./hooks"
import {AppArgs, INPUT_DATA_ID, Item, ModalArg} from "./types"
import {iconClass} from "./icon"

const mount = () =>
  document.querySelectorAll(".mount-rails-omnibar").forEach((node) => {
    const propScript = node.querySelector("script[type='application/json']")
    if (!propScript) return

    const props = JSON.parse(propScript.innerHTML) as AppArgs
    propScript.remove()
    render(<App {...props} />, node)
  })

document.addEventListener("DOMContentLoaded", mount)

document.addEventListener("turbo:load", mount)

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
  const loadingStyle = useDelayedLoadingStyle()

  return (
    <>
      <Omnibar<Item>
        data-id={INPUT_DATA_ID}
        extensions={extensions}
        maxResults={args.maxResults}
        onAction={itemAction}
        onQueryStart={() => loadingStyle.startTimer()}
        onQueryEnd={() => loadingStyle.stop()}
        placeholder={args.placeholder}
        children={(props) => renderItem({...props, modal: args.modal})}
        showEmpty
        style={{
          ...(args.modal ? MODAL_ROW_STYLE : ROW_STYLE),
          ...loadingStyle.style,
        }}
      />
      {args.itemModal.modal}
    </>
  )
}

const RailsOmnibarAsModal: FunctionComponent<AppArgs & ModalArg> = (args) => {
  const {modal, toggle} = useModal(<RailsOmnibar {...args} />, 0)
  useHotkey(args.hotkey, toggle)

  return modal
}

const renderItem = (
  props: Omnibar.ResultRendererArgs<Item> & {modal: boolean}
) => {
  const {item, onMouseEnter, onMouseLeave, onClick} = props
  const handlers = {onMouseEnter, onMouseLeave, onClick} as Record<
    string,
    (e: any) => void
  >
  const style = buildItemStyle<Item>(props) as React.JSX.CSSProperties
  const Icon = iconClass(item.icon)

  return (
    <div
      {...handlers}
      style={{...style, ...(props.modal ? MODAL_ROW_STYLE : ROW_STYLE)}}
    >
      {Icon && <Icon name={item.icon} style={ICON_STYLE} />}
      {item.title}
    </div>
  )
}

const ROW_HEIGHT = 36

const ROW_STYLE = {
  height: ROW_HEIGHT,
  fontSize: ROW_HEIGHT / 2,
  lineHeight: `${ROW_HEIGHT}px`,
}

const MODAL_ROW_STYLE = {
  ...ROW_STYLE,
  border: 0,
}

const ICON_STYLE = {
  all: "revert" as Globals,
  height: ROW_HEIGHT / 2,
  width: ROW_HEIGHT / 2,
  paddingRight: ROW_HEIGHT / 8,
  verticalAlign: "text-top",
}
