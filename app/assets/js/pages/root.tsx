import { Footer } from "@/components/footer"
import { Header } from "@/components/header"
import { NavBar } from "@/components/navbar"
import { cn } from "@/utils/styling"
import { Outlet, useNavigation } from "react-router-dom"

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
    </>
  )
}
