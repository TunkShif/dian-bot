import { UserService } from "@/services"
import { useQuery } from "@tanstack/react-query"

export const useCurrentUser = () => useQuery(UserService.queries.current)
