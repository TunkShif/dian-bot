import { NavMenu } from "@/components/navbar"
import { ThemeToggle } from "@/components/theme"
import { Link } from "react-router-dom"

export const Header = () => {
  return (
    <header className="flex p-4 bg-card justify-between items-center border-b">
      <div className="flex justify-start items-center gap-8">
        <Link to="/">
          <div className="inline-flex items-baseline gap-3">
            <span className="text-xl">📕</span>
            <span className="font-medium hover:underline"> Little Red Book</span>
          </div>
        </Link>
        <NavMenu />
      </div>
      <div className="flex justify-end items-center">
        <ThemeToggle />
      </div>
    </header>
  )
}
