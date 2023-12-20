import { UserService } from "@/services"
import { queryClient } from "@/utils/client"
import { LoaderFunctionArgs, redirect } from "react-router-dom"
import { toast } from "sonner"

export const wrappedLoader = async ({ }: LoaderFunctionArgs) => {
  const user = await queryClient.fetchQuery(UserService.queries.current)
  if (!user) {
    toast.error("要先登录哦")
    throw redirect("/users/login")
  }
  return {}
}

export const Wrapped2023 = () => {
  return <>blahblah</>
}
