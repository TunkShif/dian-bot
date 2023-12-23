import { CSSDoodle } from "@/components/shared/css-doodle"
import { UserAvatar } from "@/components/shared/user-avatar"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { AwardIcon, BananaIcon, CalendarIcon, MoveLeftIcon } from "lucide-react"
import { Link } from "react-router-dom"
import { useWrappedLoaderData } from "./page"

const PixelBackground = () => {
  return (
    <CSSDoodle
      className="absolute inset-0"
      rule={`
        @grid: 1 / 100% 100vh / #0a0c27;
        background-size: 200px 200px;
        background-image: @doodle(
          @grid: 6 / 100%;
          @size: 4px;
          font-size: 4px;
          color: hsl(@r240, 30%, 50%);
          box-shadow: @m3x5(
            calc(4em - @nx*1em) @ny(*1em)
              @p(@m3(currentColor), @m2(#0000)),
            calc(2em + @nx*1em) @ny(*1em)
              @lp
          );
        );
`}
    />
  )
}

export const ProfileCard = () => {
  const {
    user,
    statistics: { counts }
  } = useWrappedLoaderData()

  return (
    <Card className="relative h-full overflow-hidden">
      <PixelBackground />

      <div className="relative w-full flex flex-col justify-center items-center gap-16 px-4 py-8 md:p-16">
        <div>
          <UserAvatar user={user} className="w-32 h-32 md:w-36 md:h-36" />
        </div>

        <div className="bg-slate-950/90 text-gray-50 flex flex-col gap-4 w-full px-4 py-6 rounded-md">
          <h1 className="text-lg md:text-xl font-semibold">ANNUAL RECORDS</h1>
          <div className="flex items-center gap-2">
            <CalendarIcon className="w-5 h-5" />
            <div className="text-sm">
              Year <span className="font-medium">2023</span>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <BananaIcon className="w-5 h-5" />
            <div className="text-sm">
              共设精 <span className="font-medium">{counts.as_operator || 0}</span> 次
            </div>
          </div>

          <div className="flex items-center gap-2">
            <AwardIcon className="w-5 h-5" />
            <div className="text-sm">
              已入典 <span className="font-medium">{counts.as_sender || 0}</span> 次
            </div>
          </div>
        </div>
      </div>

      <div className="absolute bottom-2 left-2">
        <Button variant="link" className="text-gray-50" asChild>
          <Link to="/">
            <MoveLeftIcon className="w-5 h-5 mr-2" />
            <div className="text-sm">返回首页</div>
          </Link>
        </Button>
      </div>
    </Card>
  )
}
