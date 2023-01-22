export const INPUT_DATA_ID = "rails-omnibar"

export type AppArgs = {
  calculator: boolean
  commandPattern: JsRegex
  hotkey: string
  items: Array<Item>
  maxResults: number
  modal: boolean
  placeholder?: string
  queryPath?: string
}

export type Item = {
  title: string
  url?: string
  modalHTML?: string
  type: "default" | "help"
}

export type JsRegex = {
  source: string
  options: string
}

export type ModalBag = {
  modal: JSX.Element
  setBody: (v: JSX.Element) => void
  toggle: () => void
}

export type ModalArg = {
  itemModal: ModalBag
}
