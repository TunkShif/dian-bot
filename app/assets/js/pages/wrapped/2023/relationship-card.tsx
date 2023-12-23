import { UserAvatar } from "@/components/shared/user-avatar"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { User } from "@/services"
import { MoveRightIcon } from "lucide-react"
import React from "react"
import { useSliderControl } from "./slider-control"

const user = {
  id: 2,
  number: "1395084414",
  nickname: "ܛܟܫܦ",
  avatar_url: "/api/messenger/users/avatar/1395084414"
} satisfies User

const pick = <T,>(list: T[]) => list.at(Math.floor(Math.random() * list.length)) as T

const sizes = [24, 32, 48, 72, 96]
const offsets = [10, 20, 25, 40, 45, 60, 65, 70, 75, 80, 85]
const delays = [0, 2, 3, 5, 7, 8, 10]
const durations = [5, 7, 9, 10, 15, 20, 28, 35, 48]

const Heart: React.FC<{ className?: string; style?: React.CSSProperties }> = ({
  className,
  style
}) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 20 20"
    fill="currentColor"
    style={style}
    className={className}
  >
    <path d="m9.653 16.915-.005-.003-.019-.01a20.759 20.759 0 0 1-1.162-.682 22.045 22.045 0 0 1-2.582-1.9C4.045 12.733 2 10.352 2 7.5a4.5 4.5 0 0 1 8-2.828A4.5 4.5 0 0 1 18 7.5c0 2.852-2.044 5.233-3.885 6.82a22.049 22.049 0 0 1-3.744 2.582l-.019.01-.005.003h-.002a.739.739 0 0 1-.69.001l-.002-.001Z" />
  </svg>
)

const BubblingBackground = () => {
  return (
    <div className="absolute inset-0 bg-[linear-gradient(120deg,#e0c3fc_0%,#8ec5fc_100%)]">
      {Array(18)
        .fill(undefined)
        .map((_, i) => {
          const size = pick(sizes)
          return (
            <Heart
              key={`bubble-${i}`}
              className="block absolute -bottom-20 w-5 h-5 text-pink-50/40 animate-bubbling"
              style={{
                left: `${pick(offsets)}%`,
                width: `${size}px`,
                height: `${size}px`,
                animationDelay: `${pick(delays)}s`,
                animationDuration: `${pick(durations)}s`
              }}
            />
          )
        })}
    </div>
  )
}

export const RelationshipCard = () => {
  const nextSlide = useSliderControl()

  return (
    <Card className="relative h-full overflow-hidden">
      <BubblingBackground />
      <div className="relative flex flex-col justify-center items-center py-8 md:py-16">
        <div className="text-center">
          <UserAvatar user={user} className="w-16 h-16" />
          <div className="mt-2">{user.nickname}</div>
        </div>

        <div className="my-8 relative h-16 w-16">
          <Heart className="absolute h-full w-full text-pink-400 animate-ping" />
          <Heart className="relative h-16 w-16 text-pink-500" />
        </div>

        <div className="flex justify-center items-center gap-16">
          <div className="text-center">
            <UserAvatar user={user} className="w-16 h-16" />
            <div className="mt-2">{user.nickname}</div>
          </div>
          <div className="text-center">
            <UserAvatar user={user} className="w-16 h-16" />
            <div className="mt-2">{user.nickname}</div>
          </div>
        </div>

        <div className="mt-16 text-lg md:text-2xl font-medium space-y-4">
          <div>
            <span className="font-semibold">{user.nickname} </span> 是你最爱设精的人
          </div>
          <div>
            <span className="font-semibold">{user.nickname} </span> 是为你设精最多的人
          </div>
        </div>
      </div>

      <div className="absolute bottom-2 right-2">
        <Button variant="link" className="text-gray-50" onClick={nextSlide}>
          <MoveRightIcon className="w-5 h-5 mr-2" />
          <div className="text-sm">NEXT</div>
        </Button>
      </div>
    </Card>
  )
}
