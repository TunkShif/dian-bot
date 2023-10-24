import { useCurrentUser } from "@/components/hooks/use-current-user"
import { preferencesAtom } from "@/pages/atoms"
import { useAtomValue } from "jotai/react"
import { TypeAnimation } from "react-type-animation"

const sequence = [
  "Hello",
  "你好",
  "Hola",
  "Hallo",
  "Bonjour",
  "こんにちは",
  "Merhaba",
  "سلام"
].flatMap((text) => [text, 1000])

export const WelcomeInfo = () => {
  const { data: user } = useCurrentUser()
  const preferences = useAtomValue(preferencesAtom)

  if (!user) return null

  return (
    <div className="font-semibold">
      <TypeAnimation
        sequence={sequence}
        speed={10}
        repeat={preferences.repeatTypingAnimation ? Infinity : undefined}
        wrapper="h2"
        style={{ fontSize: "2.25rem", lineHeight: "2.5rem" }}
      />
      <div className="text-2xl md:text-3xl">{user.nickname}</div>
    </div>
  )
}
