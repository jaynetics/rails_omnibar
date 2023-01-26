import React, {FunctionComponent} from "preact"
import habitat from "preact-habitat"
import {useItemAction, useResolvers} from "./hooks"
import {useModal} from "./hooks"
import {AppArgs, Item} from "./types"
import {useEffect, useRef, useState} from "preact/hooks"
import {useDebouncedEffect} from "./hooks/use_debounced_effect"

import "react-cmdk/dist/cmdk.css"
import CommandPalette, {filterItems, getItemIndex} from "react-cmdk"

const App: FunctionComponent<AppArgs> = (args) => {
  const [page, setPage] = useState<"root" | "projects">("root")
  const [open, setOpen] = useState<boolean>(true)
  const [search, setSearch] = useState("")

  const filteredItems = filterItems(
    [
      {
        id: "default",
        items: [
          {
            id: "home",
            icon: "HomeIcon",
            href: "#",
          },
          {
            id: "settings",
            icon: "CogIcon",
            href: "#",
          },
          {
            id: "projects",
            icon: "HomeIcon",
            closeOnSelect: false,
          },
        ],
      },
    ],
    search
  )

  return (
    <CommandPalette
      onChangeSearch={setSearch}
      onChangeOpen={setOpen}
      search={search}
      isOpen={open}
      page={page}
    >
      {filteredItems.length
        ? filteredItems.map((list) => (
            <CommandPalette.List key={list.id} heading={list.heading}>
              {
                list.items.map(({id, ...rest}) => (
                  <CommandPalette.ListItem
                    key={id}
                    index={getItemIndex(filteredItems, id)}
                    {...rest}
                  />
                )) as any
              }
            </CommandPalette.List>
          ))
        : ((<CommandPalette.FreeSearchAction />) as any)}
    </CommandPalette>
  )
}

// export default Example

document.addEventListener("DOMContentLoaded", () => {
  habitat(App).render({selector: "#mount-rails-omnibar"})
})

// const App
//   return (
//     <KBarProvider actions={[]}>
//       <KBarPortal>
//         <KBarPositioner>
//           <KBarAnimator>
//             <KBarSearch />
//           </KBarAnimator>
//         </KBarPositioner>
//       </KBarPortal>
//     </KBarProvider>
//   )
//   const itemModal = useModal()
//   const handler = useItemAction(itemModal)
//   const [q, setQ] = useState("")
//   const resolvers = useResolvers(args)

//   useDebouncedEffect(() => {
//     const run = async () => {
//       let matches = new Array<Item>()
//       for (let i = 0; i < resolvers.length; i++) {
//         matches = [...matches, ...(await resolvers[i](q))]
//       }
//       // ninjaKeys.current!.data = matches.map((item) => ({
//       //   handler: handler.bind(null, item),
//       //   id: String(Math.random()),
//       //   keywords: q, // make sure the result appears
//       //   title: item.title as string,
//       // }))
//     }
//     run()
//   }, [resolvers, q])

//   // useEffect(() => {
//   //   ninjaKeys.current?.addEventListener("change", (e: any) => {
//   //     setQ(e.detail.search)
//   //   })
//   // }, [setQ])

//   return <>{itemModal.modal}</>
// }
