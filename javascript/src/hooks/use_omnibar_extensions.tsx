import React, {useMemo} from "preact/hooks"
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
  return (q: string) => {
    const results = fuzzysort.go(q, items, {key: "title"})
    return results.map((result) => ({
      ...result.obj, // Item
      title: (
        <>
          {fuzzysort.highlight(result, (match) => (
            <span style={staticWidthBoldStyle}>{match}</span>
          ))}
        </>
      ),
    }))
  }
}

const staticWidthBoldStyle = {
  textShadow: "-0.06ex 0 0 currentColor, 0.06ex 0 0 currentColor",
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
