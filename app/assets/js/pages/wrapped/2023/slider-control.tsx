import { createContext, useContext } from "react"

type NextSlide = () => void

export const SliderControlContext = createContext<NextSlide>(() => { })

export const useSliderControl = () => useContext(SliderControlContext)
