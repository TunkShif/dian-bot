import { UserAvatar } from "@/components/shared/user-avatar"
import { WithUserHoverCard } from "@/components/shared/user-card"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip"
import { StatisticsService } from "@/services"
import { TooltipPortal } from "@radix-ui/react-tooltip"
import { useQuery } from "@tanstack/react-query"
import HeatMap from "@uiw/react-heat-map"
import { format, subDays } from "date-fns"
import {
  ActivityIcon,
  BarChart4Icon,
  CalendarDaysIcon,
  MoveRightIcon,
  RadiationIcon
} from "lucide-react"
import { Link, useNavigate } from "react-router-dom"
import { Bar, BarChart, ResponsiveContainer, XAxis, YAxis } from "recharts"

const useDashboardStatisticsQuery = () => useQuery(StatisticsService.queries.dashboard)
const useHeatMapStatisticsQuery = () => useQuery(StatisticsService.queries.heatmap)

export const DailyActivityCard = () => {
  const { data } = useDashboardStatisticsQuery()
  const {
    latest_activity_counts: { today, yesterday }
  } = data!
  const difference = today - yesterday

  return (
    <Card>
      <CardHeader className="flex flex-row justify-between items-center pb-2">
        <h3 className="tracking-tight text-sm font-medium">今日新增入典</h3>
        <ActivityIcon className="w-5 h-5" />
      </CardHeader>
      <CardContent className="flex justify-between items-end">
        <div>
          <div className="text-2xl font-bold">+{today}</div>
          <p className="text-xs text-muted-foreground">
            相比昨天{" "}
            <span className="font-medium text-foreground">
              {difference > 0 ? "+" : null}
              {difference}
            </span>
          </p>
        </div>
        <Button variant="outline" size="sm" asChild>
          <Link to={`/archive?date=${format(new Date(), "yyyy-MM-dd")}`}>
            <MoveRightIcon className="w-5 h-5 mr-2" />
            <span>查看</span>
          </Link>
        </Button>
      </CardContent>
    </Card>
  )
}

export const MostRecentActiveUserCard = () => {
  const { data } = useDashboardStatisticsQuery()
  const { most_recent_active_user: user } = data!

  return (
    <Card>
      <CardHeader className="flex flex-row justify-between items-center pb-2">
        <h3 className="tracking-tight text-sm font-medium">最新爆典的是</h3>
        <RadiationIcon className="w-5 h-5" />
      </CardHeader>
      <CardContent className="flex justify-between items-end">
        <Tooltip delayDuration={500}>
          <TooltipTrigger>
            <div>
              <div className="flex gap-2 items-center">
                <UserAvatar user={user} className="w-9 h-9" />
                <div className="flex flex-col justify-start items-start">
                  <span className="text-sm md:text-base">{user.nickname}</span>
                  <span className="text-xs md:text-sm">({user.number})</span>
                </div>
              </div>
            </div>
          </TooltipTrigger>
          <TooltipContent>
            <p>老东西又爆了</p>
          </TooltipContent>
        </Tooltip>

        <Button variant="outline" size="sm" asChild>
          <Link to={`/archive`}>
            <MoveRightIcon className="w-5 h-5 mr-2" />
            <span>查看</span>
          </Link>
        </Button>
      </CardContent>
    </Card>
  )
}

export const WeeklyActivityChartCard = () => {
  const { data } = useDashboardStatisticsQuery()
  const { last_week_activity_counts: stats } = data!

  return (
    <Card>
      <CardHeader className="flex flex-row justify-start items-center gap-2">
        <CardTitle className="flex items-center">
          <BarChart4Icon className="w-5 h-5 mr-2" />
          上周入典总览
        </CardTitle>
      </CardHeader>
      <CardContent className="px-0">
        <ResponsiveContainer width="100%" height={320}>
          <BarChart data={stats}>
            <XAxis
              dataKey="date"
              stroke="#888888"
              fontSize={12}
              tickLine={false}
              axisLine={false}
              padding={{ left: 0 }}
              tickFormatter={(value) => `${format(new Date(value), "E")}`}
            />
            <YAxis stroke="#888888" fontSize={12} tickLine={false} axisLine={false} />
            <Bar dataKey="count" fill="#09090b" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  )
}

export const MonthlyActiveUserCard = () => {
  const { data } = useDashboardStatisticsQuery()
  const { last_month_active_users: users } = data!

  return (
    <Card>
      <CardHeader>
        <CardTitle>上月入典排行榜</CardTitle>
        <CardDescription>看看你在哪</CardDescription>
      </CardHeader>
      <CardContent>
        <ul className="flex flex-col gap-6">
          {users.map(({ count, sender }) => (
            <li key={sender.id}>
              <div className="flex items-center">
                <UserAvatar user={sender} className="w-11 h-11 mr-3" />

                <WithUserHoverCard user={sender}>
                  <div className="flex flex-col justify-center gap-0.5 cursor-pointer">
                    <span>{sender.nickname}</span>
                    <span className="text-xs">({sender.number})</span>
                  </div>
                </WithUserHoverCard>

                <div className="ml-auto font-bold text-2xl">+{count}</div>
              </div>
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  )
}

export const HeatMapCard = () => {
  const { data } = useHeatMapStatisticsQuery()
  const navigate = useNavigate()

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center">
          <CalendarDaysIcon className="w-5 h-5 mr-2" />
          最近入典统计
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="overflow-x-auto">
          <HeatMap
            width={680}
            height={180}
            space={4}
            value={data ?? []}
            startDate={subDays(new Date(), 30 * 6)}
            rectSize={16}
            rectProps={{ rx: 1.6 }}
            rectRender={(props, data) =>
              data.count ? (
                <Tooltip>
                  <TooltipTrigger asChild>
                    <rect
                      {...props}
                      onClick={() =>
                        navigate(`/archive?date=${format(new Date(data.date), "yyyy-MM-dd")}`)
                      }
                    />
                  </TooltipTrigger>
                  <TooltipPortal>
                    <TooltipContent>
                      <p>{`${data.count} 次入典记录 ${data.date}`}</p>
                    </TooltipContent>
                  </TooltipPortal>
                </Tooltip>
              ) : (
                <rect {...props} />
              )
            }
            legendCellSize={0}
          />
        </div>
      </CardContent>
    </Card>
  )
}
