import { addHours, format, parseISO } from "date-fns"

export const formatDate = (date: string) => format(addHours(parseISO(date), 8), "yyyy-MM-dd HH:mm")
