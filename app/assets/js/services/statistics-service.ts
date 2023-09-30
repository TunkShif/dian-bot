import type { Data, ListData, User } from "@/services"
import ky from "ky"

export type Hotword = {
  id: number
  keyword: string
}

export type DashboardStatistics = {
  most_recent_active_user: User
  latest_activity_counts: { today: number; yesterday: number }
  last_week_activity_counts: { count: number; date: string }[]
  last_month_active_users: { count: number; sender: User }[]
}

export const StatisticsService = {
  listHotwords() {
    return ky.get("/api/statistics/hotwords").json<ListData<Hotword>>()
  },
  getDashboardStatistics() {
    return ky.get("/api/statistics/dashboard").json<Data<DashboardStatistics>>()
  },
  getUserStatistcs(id: string | number) {
    return ky
      .get(`/api/statistics/user/${id}`)
      .json<Data<{ as_operator: number; as_sender: number }>>()
  },
  queries: {
    hotwords: {
      queryKey: ["statistics", "hotwords"],
      queryFn: () => StatisticsService.listHotwords().then(({ data }) => data),
      refetchOnWindowFocus: false
    },
    dashboard: {
      queryKey: ["statistics", "dashboard"],
      queryFn: () => StatisticsService.getDashboardStatistics().then(({ data }) => data)
    },
    user: (id: string | number | null) => ({
      queryKey: ["statistics", "user", id],
      queryFn: () => StatisticsService.getUserStatistcs(id!).then(({ data }) => data),
      enabled: !!id
    })
  }
}
