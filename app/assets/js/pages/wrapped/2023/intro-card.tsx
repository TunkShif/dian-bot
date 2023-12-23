import { Card } from "@/components/ui/card"
import { useSliderControl } from "./slider-control"

export const IntroCard = () => {
  const nextSlide = useSliderControl()

  return (
    <Card className="flex justify-center items-center h-full bg-liquid-gradient">
      <div className="flex flex-col items-center gap-8">
        <div>
          <h1 className="bg-text-sliding text-6xl md:text-7xl font-extrabold">
            2023
            <br />
            Wrapped
          </h1>
        </div>
        <button className="text-sm md:text-base text-sky-900 font-medium" onClick={nextSlide}>
          点击进入
        </button>
      </div>
    </Card>
  )
}
