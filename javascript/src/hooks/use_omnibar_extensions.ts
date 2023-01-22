import {useMemo} from "preact/hooks"
import {AppArgs, Item} from "../types"
import fuzzysort from "fuzzysort"
import {tryCalculate} from "yaam"

export const useOmnibarExtensions = (args: AppArgs) => {
  return useMemo(() => [commands(args), items(args), calculator(args)], [args])
}

const commands = ({commandPattern: p, queryPath}: AppArgs) => {
  const commandRegexp = useMemo(() => p && new RegExp(p.source, p.options), [p])

  return async (q: string) => {
    if (!queryPath || !commandRegexp?.test(q)) return []

    const response = await fetch(`${queryPath}&q=${q}`)
    return await response.json()
  }
}

const items = ({items}: AppArgs) => {
  return (q: string) => fuzzysort.go(q, items, {key: "title"}).map((r) => r.obj)
}

const calculator = ({calculator}: AppArgs) => {
  return (q: string) => {
    const result = calculator ? tryCalculate(q) : null
    if (result !== null) {
      return [{title: String(result), type: "default" as Item["type"]}]
    }
    return new Array<Item>()
  }
}
