import { Footer } from "@/components/footer"
import { Header } from "@/components/header"
import { NavBar } from "@/components/navbar"
import { UserService } from "@/services"
import { queryClient } from "@/utils/client"
import { cn } from "@/utils/styling"
import { Outlet, useLoaderData, useNavigation, type LoaderFunctionArgs } from "react-router-dom"
import { Toaster, toast } from "sonner"

export const rootLoader = async ({ request }: LoaderFunctionArgs) => {
  const searchParams = new URL(request.url).searchParams
  await queryClient.prefetchQuery(UserService.queries.current)

  if (searchParams.has("login_success")) {
    setTimeout(() => toast.success("登录成功"), 500)
  }

  return {}
}

export const userRootLoaderData = () => useLoaderData() as Awaited<ReturnType<typeof rootLoader>>

export const Root = () => {
  const navigation = useNavigation()

  return (
    <>
      <Header />
      <main
        className={cn("p-4 mx-auto md:max-w-3xl", navigation.state === "loading" && "opacity-60")}
      >
        <Outlet />
      </main>
      <Footer />
      <NavBar />
      <Toaster position="top-center" />
    </>
  )
}
