import { CSSDoodle } from "@/components/shared/css-doodle"
import { UserAvatar } from "@/components/shared/user-avatar"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { MoveRightIcon, RefreshCcwIcon } from "lucide-react"
import { CSSProperties, useState } from "react"
import { useSliderControl } from "./slider-control"

const RadicalSplashBackground = () => (
  <CSSDoodle
    className="absolute inset-0"
    rule={`
      <style>
        @grid: 50x1 / 100%;
        :container {
          perspective: 23vmin;
        }
        background: @m(
          @r(200, 240), 
          radial-gradient(
            @p(#00b8a9, #f8f3d4, #f6416c, #ffde7d) 15%,
            transparent 50%
          ) @r(100%) @r(100%) / @r(1%, 3%) @lr no-repeat
        );

        @place-cell: center;

        border-radius: 50%;
        transform-style: preserve-3d;
        animation: scale-up 20s linear infinite;
        animation-delay: calc(@i * -.4s);

        @keyframes scale-up {
          0% {
            opacity: 0;
            transform: translate3d(0, 0, 0) rotate(0);
          }
          10% { 
            opacity: 1; 
          }
          95% {
            transform:
              translate3d(0, 0, @r(50vmin, 55vmin))
              rotate(@r(-360deg, 360deg));
          }
          100% {
            opacity: 0;
            transform: translate3d(0, 0, 1vmin);
          }
        }
      </style>
`}
  />
)

const TOP_GROUPS = [
  { name: "🍅蒙德🍅🍅🍅", count: 1929 },
  { name: "Pooh the Small Bear", count: 161 },
  { name: "坏手艺esu", count: 56 },
  { name: "我喜欢你", count: 18 },
  { name: "元梦之翔", count: 11 }
]

const TOP_USERS = [
  {
    user: {
      id: 16,
      nickname: "HHruarua",
      number: "1195188422",
      avatar_url: "/api/messenger/users/avatar/1195188422"
    },
    count: 296
  },
  {
    user: {
      id: 5,
      nickname: "780",
      number: "1619162044",
      avatar_url: "/api/messenger/users/avatar/1619162044"
    },
    count: 225
  },
  {
    user: {
      id: 14,
      nickname: "Dylech30th",
      number: "2653221698",
      avatar_url: "/api/messenger/users/avatar/2653221698"
    },
    count: 202
  },
  {
    user: {
      id: 21,
      nickname: "锌锂铱砷",
      number: "1141946313",
      avatar_url: "/api/messenger/users/avatar/1141946313"
    },
    count: 193
  },
  {
    user: {
      id: 7,
      nickname: "冯•鲁道夫",
      number: "2665187332",
      avatar_url: "/api/messenger/users/avatar/2665187332"
    },
    count: 160
  }
]

const TopGroupList = () => {
  return (
    <div className="relative before:bg-[linear-gradient(to_top,#a8edea_0%,#fed6e3_100%)] before:absolute before:inset-0 before:opacity-90 px-4 py-6 md:py-8 rounded-md">
      <div className="relative">
        <h2 className="text-2xl font-semibold">TOP GROUPS</h2>
        <p className="mt-2 mb-4 text-sm md:text-base">来看看爆典最多的群</p>
        <ul className="flex flex-col gap-4">
          {TOP_GROUPS.map(({ name, count }, i) => (
            <li
              key={name}
              className="animate-line-fade-in"
              style={{ animationDelay: `${(i - 1) * 1.5}s` }}
            >
              <div className="text-base md:text-lg flex justify-between items-center">
                <h3 className="font-medium">
                  <span>{i + 1}. </span> {name}
                </h3>
                <span>{count}</span>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  )
}

const TopUserList = () => {
  return (
    <div className="relative before:bg-[linear-gradient(to_top,#a8edea_0%,#fed6e3_100%)] before:absolute before:inset-0 before:opacity-90 px-4 py-6 md:py-8 rounded-lg">
      <div className="relative">
        <h2 className="text-2xl font-semibold">TOP USERS</h2>
        <p className="mt-2 mb-4 text-sm md:text-base">来看看爆典最多的用户</p>
        <ul className="flex flex-col gap-4">
          {TOP_USERS.map(({ user, count }, i) => (
            <li
              key={i}
              className="animate-line-fade-in"
              style={{ animationDelay: `${(i - 1) * 1.5}s` }}
            >
              <div className="text-base md:text-lg flex justify-between items-center">
                <div className="flex items-center gap-1.5 truncate">
                  <span>{i + 1}. </span>
                  <UserAvatar user={user} />
                  <span>{user.nickname}</span>
                </div>
                <span className="shrink-0">{count}</span>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  )
}

export const OverviewCard: React.FC<{ index: number }> = ({ index }) => {
  const nextSlide = useSliderControl()
  const [current, setCurrent] = useState(1)
  const flip = () => setCurrent((prev) => -prev)

  if (index !== 1) return null

  return (
    <Card className="relative bg-black h-full">
      <RadicalSplashBackground />

      <div className="absolute inset-0 flex flex-col gap-4 px-4 py-8 md:p-16">
        <h1 className="text-gray-50 text-base md:text-xl font-semibold space-y-2">
          <div>
            今年的入典量达到了
            <span className="animate-count-up" style={{ "--total": 2172 } as CSSProperties} />条
          </div>
          <div>
            用户数量达到了
            <span className="animate-count-up" style={{ "--total": 89 } as CSSProperties} />人
          </div>
        </h1>

        <div className="relative">
          <Button
            variant="ghost"
            size="icon"
            className="z-10 absolute top-2 right-2"
            onClick={flip}
          >
            <RefreshCcwIcon className="w-4 h-4 text-slate-800" />
          </Button>
          {current > 0 ? <TopGroupList /> : <TopUserList />}
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
