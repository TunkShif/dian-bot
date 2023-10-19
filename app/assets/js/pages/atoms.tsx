import { atomWithStorage } from "jotai/utils"

export type Preferences = {
  renderMarkdown: boolean
}

export const preferencesAtom = atomWithStorage<Preferences>("dian_preferences", {
  renderMarkdown: true
})
