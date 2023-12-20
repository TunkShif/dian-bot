import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { SparklesIcon } from "lucide-react"
import { Link } from "react-router-dom"

export const WrappedCard = () => {
  return (
    <Link to="/wrapped/2023">
      <Card className="bg-gradient-to-br from-[#FFDDCC] via-[#fff1eb] to-[#CCFFFF] dark:bg-[linear-gradient(270deg,#8baaaa_0%,#ae8b9c_100%)]">
        <CardHeader>
          <h2 className="flex items-center gap-4">
            <div className="flex shrink-0 justify-center items-center w-10 h-10 shadow-sm shadow-purple-400/50 rounded-md bg-[linear-gradient(120deg,#a6c0fe_0%,#f68084_100%)]">
              <SparklesIcon className="text-pink-50" />
            </div>
            <span className="font-semibold text-lg">2023 Wrapped</span>
          </h2>
        </CardHeader>
        <CardContent className="flex justify-between items-center">
          <p className="">查看属于你的年度入典总结!</p>
        </CardContent>
      </Card>
    </Link>
  )
}
