import {
  DailyActivityCard,
  MonthlyActiveUserCard,
  MostRecentActiveUserCard,
  WeeklyActivityChartCard
} from "@/pages/dashboard/statistics-cards"
import { WelcomeInfo } from "@/pages/dashboard/welcome-info"
import { WrappedCard } from "@/pages/dashboard/wrapped-card"
import { StatisticsService } from "@/services"
import { queryClient } from "@/utils/client"
import { Helmet } from "react-helmet-async"
import { type LoaderFunctionArgs } from "react-router-dom"

export const dashboardLoder = async ({ }: LoaderFunctionArgs) => {
  const query = StatisticsService.queries.dashboard

  if (!queryClient.getQueryData(query.queryKey)) {
    await queryClient.fetchQuery(query)
  }

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
        <section className="empty:hidden">
          <WrappedCard />
        </section>
        <section className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <MostRecentActiveUserCard />
          <DailyActivityCard />
        </section>
        <section className="flex flex-col gap-4">
          <WeeklyActivityChartCard />
          <MonthlyActiveUserCard />
        </section>
      </div>
    </>
  )
}
