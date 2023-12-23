import { Card, CardContent, CardHeader } from "@/components/ui/card"
import confetti from "canvas-confetti"
import { SparklesIcon } from "lucide-react"
import { useEffect } from "react"
import { Link } from "react-router-dom"

const randomInRange = (min: number, max: number) => Math.random() * (max - min) + min

const firework = () => {
  const duration = 15 * 1000
  const animationEnd = Date.now() + duration
  const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 }

  const intervalId = setInterval(function() {
    var timeLeft = animationEnd - Date.now()

    if (timeLeft <= 0) {
      return clearInterval(intervalId)
    }

    var particleCount = 50 * (timeLeft / duration)
    confetti({
      ...defaults,
      particleCount,
      origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 }
    })
    confetti({
      ...defaults,
      particleCount,
      origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 }
    })
  }, 250)

  return intervalId
}

export const WrappedCard = () => {
  useEffect(() => {
    const cancelId = firework()
    return () => clearInterval(cancelId)
  }, [])

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
