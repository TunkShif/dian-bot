import { Button } from "@/components/ui/button"
import { cn } from "@/utils/styling"
import { ArchiveIcon, HomeIcon, ImageIcon, Settings2Icon } from "lucide-react"
import MediaQuery from "react-responsive"
import { NavLink } from "react-router-dom"

const NAV_ITEMS = [
  {
    Icon: HomeIcon,
    label: "首页",
    route: "/dashboard"
  },
  {
    Icon: ArchiveIcon,
    label: "典库",
    route: "/archive"
  },
  {
    Icon: ImageIcon,
    label: "图集",
    route: "/gallery"
  },
  {
    Icon: Settings2Icon,
    label: "设定",
    route: "/preferences"
  }
]

export const NavMenu = () => {
  return (
    <MediaQuery minWidth={768}>
      <nav>
        <ul className="flex items-center gap-2">
          {NAV_ITEMS.map(({ label, route, Icon }) => (
            <li key={label} className="">
              <NavLink to={route}>
                {({ isActive }) => (
                  <Button
                    variant="ghost"
                    className={cn("inline-flex gap-2 items-center", isActive && "bg-accent")}
                  >
                    <Icon className="w-5 h-5" />
                    <span>{label}</span>
                  </Button>
                )}
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </MediaQuery>
  )
}

export const NavBar = () => {
  return (
    <MediaQuery maxWidth={768}>
      <nav className="fixed flex items-center h-20 px-2 inset-x-0 bottom-0 bg-card border-t">
        <ul className="w-full grid grid-cols-4 gap-0.5">
          {NAV_ITEMS.map(({ label, route, Icon }) => (
            <li key={label} className="inline-flex justify-center items-center">
              <NavLink to={route}>
                {({ isActive }) => (
                  <Button
                    variant="ghost"
                    size="lg"
                    className={cn("w-full flex-col h-14 py-1 gap-0.5", isActive && "bg-accent")}
                    asChild
                  >
                    <div>
                      <Icon className="w-6 h-6" />
                      <span className="text-xs">{label}</span>
                    </div>
                  </Button>
                )}
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </MediaQuery>
  )
}
