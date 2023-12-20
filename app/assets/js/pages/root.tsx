import { Footer } from "@/components/footer"
import { Header } from "@/components/header"
import { NavBar } from "@/components/navbar"
import { UserService } from "@/services"
import { queryClient } from "@/utils/client"
import { cn } from "@/utils/styling"
import { useEffect } from "react"
import { Outlet, useLoaderData, useNavigation, type LoaderFunctionArgs } from "react-router-dom"
import { Toaster, toast } from "sonner"

export const rootLoader = async ({ request }: LoaderFunctionArgs) => {
  const searchParams = new URL(request.url).searchParams
  await queryClient.prefetchQuery(UserService.queries.current)

  return { loginSuccess: searchParams.has("login_success") }
}

export const userRootLoaderData = () => useLoaderData() as Awaited<ReturnType<typeof rootLoader>>

export const Root = () => {
  const navigation = useNavigation()

  const { loginSuccess } = userRootLoaderData()

  useEffect(() => {
    let toastId: string | number
    if (loginSuccess) {
      toastId = toast.success("登录成功")
    }
    return () => {
      toast.dismiss(toastId)
    }
  }, [loginSuccess])

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
