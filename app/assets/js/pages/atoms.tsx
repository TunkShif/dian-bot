import { atomWithStorage } from "jotai/utils"

export type Preferences = {
  renderMarkdown: boolean
  repeatTypingAnimation: boolean
}

export const preferencesAtom = atomWithStorage<Preferences>("dian_preferences", {
  renderMarkdown: true,
  repeatTypingAnimation: true
})
