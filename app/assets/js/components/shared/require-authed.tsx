import { UserService } from "@/services"
import { useQuery } from "@tanstack/react-query"
import React from "react"

export const RequireAuthed: React.FC<React.PropsWithChildren> = ({ children }) => {
  const { data: user } = useQuery(UserService.queries.current)
  if (!user) return null
  return children
}
