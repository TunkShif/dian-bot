import type { Data, ListData, User } from "@/services"
import { httpClient } from "@/utils/client"

export type Hotword = string

export type DashboardStatistics = {
  most_recent_active_user: User
  latest_activity_counts: { today: number; yesterday: number }
  last_week_activity_counts: { count: number; date: string }[]
  last_month_active_users: { count: number; sender: User }[]
}

export type PersonalStatistics = {
  as_operator: number
  as_sender: number
}

export type WrappedStatistics = {
  top_operator: User | null
  top_sender: User | null
  counts: PersonalStatistics
}

export const StatisticsService = {
  listHotwords() {
    return httpClient.get("/api/statistics/hotwords").json<ListData<Hotword>>()
  },
  getDashboardStatistics() {
    return httpClient.get("/api/statistics/dashboard").json<Data<DashboardStatistics>>()
  },
  getUserStatistcs(number: string) {
    return httpClient.get(`/api/statistics/user/${number}`).json<Data<PersonalStatistics>>()
  },
  getWrappedStatistics(number: string) {
    return httpClient.get(`/api/statistics/wrapped/2023/${number}`).json<Data<WrappedStatistics>>()
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
    user: (number: string | null) => ({
      queryKey: ["statistics", "user", number],
      queryFn: () => StatisticsService.getUserStatistcs(number!).then(({ data }) => data),
      enabled: !!number
    }),
    wrapped: (number: string) => ({
      queryKey: ["statistics", "wrapped", number],
      queryFn: () => StatisticsService.getWrappedStatistics(number).then(({ data }) => data),
      refetchOnWindowFocus: false
    })
  }
}
