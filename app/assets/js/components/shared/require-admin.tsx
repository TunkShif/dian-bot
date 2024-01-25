import { UserService } from "@/services"
import { useQuery } from "@tanstack/react-query"
import React from "react"

export const RequireAdmin: React.FC<React.PropsWithChildren> = ({ children }) => {
  const { data: user } = useQuery(UserService.queries.current)
  if (!user || user.role !== "admin") return null
  return children
}
