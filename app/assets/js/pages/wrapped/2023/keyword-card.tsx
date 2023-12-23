import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { MoveRightIcon } from "lucide-react"
import { Link } from "react-router-dom"
import { useSliderControl } from "./slider-control"

const KEYWORDS = [
  ["原神", 4],
  ["路遥", 5],
  ["MTF", 5],
  ["操", 3],
  ["奥利金德", 1],
  ["喜欢", 2],
  ["傻逼", 4],
  ["男娘", 6],
  ["牛", 3]
] satisfies [string, number][]

const WaveBackground = () => {
  return (
    <div className="absolute inset-0">
      <svg viewBox="0 0 1440 320" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <style>
            {`
              .wave {
                animation: wave 8s linear infinite;
              }

              .wave1 {
                animation: wave1 10s linear infinite;
              }

              .wave2 {
                animation: wave2 12s linear infinite;
              }

              @keyframes wave {
                0% {
                  transform: translateX(0%);
                }

                100% {
                  transform: translateX(100%);
                }
              }

              @keyframes wave1 {
                0% {
                  transform: scaleY(1.2) translateX(0%);
                }

                100% {
                  transform: scaleY(1.2) translateX(100%);
                }
              }

              @keyframes wave2 {
                0% {
                  transform: scaleY(.8) translateX(0%);
                }

                100% {
                  transform: scaleY(.8) translateX(100%);
                }
              }
      `}
          </style>
          <path
            id="sineWave"
            fill="#accbee"
            fill-opacity="0.3"
            d="M0,160 C320,300,420,300,740,160 C1060,20,1120,20,1440,160 V0 H0"
          />
        </defs>
        <use className="wave" href="#sineWave" />
        <use className="wave" x="-100%" href="#sineWave" />
        <use className="wave1" href="#sineWave" />
        <use className="wave1" x="-100%" href="#sineWave" />
        <use className="wave2" href="#sineWave" />
        <use className="wave2" x="-100%" href="#sineWave" />
      </svg>
    </div>
  )
}

export const KeywordCard = () => {
  const nextSlide = useSliderControl()

  return (
    <Card className="relative h-full bg-[linear-gradient(to_top,#accbee_0%,#e7f0fd_100%)] py-24 md:py-28">
      <WaveBackground />
      <div className="relative">
        <h1 className="text-xl md:text-2xl font-semibold text-center text-sky-950">
          2023 年度入典关键词
        </h1>
        <ul className="mt-16 mx-2 flex flex-wrap gap-2 justify-center items-center">
          {KEYWORDS.map(([keyword, weight]) => (
            <li
              key={keyword}
              className="bg-clip-text text-transparent bg-gradient-to-r from-[#5f83c5] to-[#6991c7] transform scale-100 hover:scale-125 transition-transform ease-in-out duration-300"
            >
              <Link
                to={`/archive?keyword=${keyword}`}
                target="_blank"
                style={{ fontSize: `${0.3 * (10 - weight) + 0.5}rem` }}
              >
                {keyword}
              </Link>
            </li>
          ))}
        </ul>
      </div>

      <div className="absolute bottom-2 right-2">
        <Button variant="link" className="text-sky-950" onClick={nextSlide}>
          <MoveRightIcon className="w-5 h-5 mr-2" />
          <div className="text-sm">NEXT</div>
        </Button>
      </div>
    </Card>
  )
}
