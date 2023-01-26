import {useMemo} from "preact/hooks"
import {AppArgs, Item} from "../types"
import fuzzysort from "fuzzysort"
import {tryCalculate} from "yaam"
import {unsafeHTML} from "lit/directives/unsafe-html.js"
import {DirectiveResult} from "lit/directive.js"
import {UnsafeHTMLDirective} from "lit/directives/unsafe-html.js"

export const useResolvers = (
  args: AppArgs
): ((q: string) => Promise<Item[]>)[] => {
  return useMemo(() => [commands(args), items(args), calculator(args)], [args])
}

const commands = ({commandPattern: p, queryPath}: AppArgs) => {
  const commandRegexp = useMemo(() => p && new RegExp(p.source, p.options), [p])

  return async (q: string): Promise<Item[]> => {
    if (!queryPath || !commandRegexp?.test(q)) return []

    const response = await fetch(`${queryPath}&q=${q}`)
    return await response.json()
  }
}

const items = ({items}: AppArgs) => {
  return async (q: string): Promise<Item[]> => {
    return fuzzysort.go(q, items, {key: "title"}).map((result) => {
      const highlightedTitle = {
        ...unsafeHTML(
          fuzzysort
            .highlight(
              result,
              (match) => `<span style="${staticWidthBoldStyle}">${match}</span>`
            )
            ?.join("")
        ),
        match: () => false, // not needed b/c INinjaAction.keywords are used
      }

      return {
        ...result.obj, // Item
        title: highlightedTitle,
      }
    })
  }
}

const staticWidthBoldStyle =
  "text-shadow: -0.06ex 0 0 currentColor, 0.06ex 0 0 currentColor"

const calculator = ({calculator}: AppArgs) => {
  return async (q: string): Promise<Item[]> => {
    const result = calculator ? tryCalculate(q) : null
    if (result !== null) {
      return [{title: String(result), type: "default" as Item["type"]}]
    }
    return new Array<Item>()
  }
}
