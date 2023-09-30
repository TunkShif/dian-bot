import { Button } from "@/components/ui/button"
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import { useArchiveLoaderData } from "@/pages/archive/page"
import { format } from "date-fns"
import { CalendarDaysIcon } from "lucide-react"
import { useNavigate } from "react-router-dom"

export const DatePicker = () => {
  const { params } = useArchiveLoaderData()
  const navigate = useNavigate()

  const date = params.date ? new Date(params.date) : undefined

  const handleSelect = (date: Date | undefined) => {
    if (!date) return
    const formatted = format(date, "yyyy-MM-dd")
    navigate(`?date=${formatted}`)
  }

  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button variant="outline" size="icon">
          <CalendarDaysIcon className="w-4 h-4" />
        </Button>
      </PopoverTrigger>

      <PopoverContent className="w-auto shadow-none p-0">
        <Calendar
          mode="single"
          className="rounded-md border"
          selected={date}
          onSelect={handleSelect}
        />
      </PopoverContent>
    </Popover>
  )
}
