import { BirdIcon } from "lucide-react"

export const Empty = () => {
  return (
    <div className="flex py-4 gap-2 justify-center items-center">
      <BirdIcon className="w-7 h-7" />
      <div className="font-medium">这里什么都没有哦</div>
    </div>
  )
}
