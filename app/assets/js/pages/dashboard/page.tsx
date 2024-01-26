import {
  DailyActivityCard,
  HeatMapCard,
  MonthlyActiveUserCard,
  MostRecentActiveUserCard,
  WeeklyActivityChartCard
} from "@/pages/dashboard/statistics-cards"
import { WelcomeInfo } from "@/pages/dashboard/welcome-info"
import { StatisticsService } from "@/services"
import { queryClient } from "@/utils/client"
import { Helmet } from "react-helmet-async"
import { type LoaderFunctionArgs } from "react-router-dom"

export const dashboardLoader = async ({}: LoaderFunctionArgs) => {
  const dashboardQuery = StatisticsService.queries.dashboard
  const heatmapQuery = StatisticsService.queries.heatmap

  const tasks: Promise<unknown>[] = []

  if (!queryClient.getQueryData(dashboardQuery.queryKey)) {
    tasks.push(queryClient.fetchQuery(dashboardQuery))
  }

  if (!queryClient.getQueryData(heatmapQuery.queryKey)) {
    tasks.push(queryClient.fetchQuery(heatmapQuery))
  }

  await Promise.all(tasks)

  return {}
}

export const Dashboard = () => {
  return (
    <>
      <Helmet>
        <title>Dashboard | Dian</title>
      </Helmet>
      <div className="space-y-4">
        <section className="empty:hidden">
          <WelcomeInfo />
        </section>
        <section className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <MostRecentActiveUserCard />
          <DailyActivityCard />
        </section>
        <section className="flex flex-col gap-4">
          <HeatMapCard />
          <WeeklyActivityChartCard />
          <MonthlyActiveUserCard />
        </section>
      </div>
    </>
  )
}
