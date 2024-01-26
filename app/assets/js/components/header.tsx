import { useCurrentUser } from "@/components/hooks/use-current-user"
import { NavMenu } from "@/components/navbar"
import { UserAvatar } from "@/components/shared/user-avatar"
import { ThemeToggle } from "@/components/theme"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuPortal,
  DropdownMenuTrigger
} from "@/components/ui/dropdown-menu"
import { LogInIcon, RssIcon } from "lucide-react"
import { Link } from "react-router-dom"

export const Header = () => {
  return (
    <header className="flex p-4 bg-card justify-between items-center border-b">
      <div className="flex justify-start items-center gap-8">
        <Link to="/">
          <div className="inline-flex items-baseline gap-2 md:gap-3">
            <span className="text-lg md:text-xl">📕</span>
            <span className="text-sm md:text-base font-medium hover:underline">
              Little Red Book
            </span>
          </div>
        </Link>
        <NavMenu />
      </div>
      <div className="flex justify-end items-center gap-2">
        <UserInfo />
        <RssFeed />
        <ThemeToggle />
      </div>
    </header>
  )
}

const RssFeed = () => {
  return (
    <Button variant="ghost" size="icon" asChild>
      <a href="/feed" target="_blank">
        <RssIcon className="h-[1.2rem] w-[1.2rem]" />
      </a>
    </Button>
  )
}

const UserInfo = () => {
  const { data: user } = useCurrentUser()

  if (!user)
    return (
      <Link to="/users/login">
        <Button variant="ghost">
          <LogInIcon className="w-5 h-5 mr-2" />
          登录
        </Button>
      </Link>
    )

  if (user)
    return (
      <>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="px-2">
              <UserAvatar user={user} className="w-7 h-7" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuPortal>
            <DropdownMenuContent>
              <DropdownMenuItem>
                <a href="/api/account/users/logout" className="w-full text-left">
                  退出登录
                </a>
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenuPortal>
        </DropdownMenu>
      </>
    )
}
