import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogTrigger } from "@/components/ui/dialog"
import { ScrollArea } from "@/components/ui/scroll-area"
import { LoadingSpinner } from "@/components/ui/spinner"
import { StatisticsService } from "@/services"
import { useQuery } from "@tanstack/react-query"
import { FlameIcon, SearchIcon } from "lucide-react"
import { useState } from "react"
import { Form, Link } from "react-router-dom"

export const SearchBar = () => {
  const { data: hotwords, isLoading } = useQuery(StatisticsService.queries.hotwords)

  const [open, setOpen] = useState(false)
  const [keyword, setKeyword] = useState("")

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" className="justify-start w-full truncate">
          <SearchIcon className="w-4 h-4 mr-2" />
          <span>按关键字搜索</span>
        </Button>
      </DialogTrigger>

      <DialogContent className="max-w-xs md:max-w-lg p-0 rounded-lg flex flex-col gap-0">
        <header className="p-4 border-b">
          <Form
            id="keyword-search"
            role="search"
            onSubmit={() => setOpen(false)}
            className="flex items-center w-full gap-2"
          >
            <SearchIcon className="w-5 h-5" />
            <input
              name="keyword"
              type="text"
              placeholder="输入关键字来查找精华消息"
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
              className="inline-flex p-0 w-full bg-transparent outline-none border-none focus:ring-0 truncate placeholder:text-muted-foreground"
            />
          </Form>
        </header>

        <h3 className="flex items-center p-4 gap-2 border-b">
          <FlameIcon className="w-5 h-5 text-red-600 dark:text-red-700" />
          <span>大家都在搜</span>
        </h3>

        <section>
          <ScrollArea className="h-96">
            <ul className="flex flex-col divide-y">
              {isLoading ? (
                <LoadingSpinner />
              ) : (
                hotwords!.map((hotword, index) => (
                  <li key={`${hotword}-${index}`} className="w-full">
                    <Link
                      to={`?keyword=${hotword}`}
                      className="flex p-4 text-left truncate hover:bg-zinc-50 dark:hover:bg-zinc-800"
                      onClick={() => setOpen(false)}
                    >
                      {hotword}
                    </Link>
                  </li>
                ))
              )}
            </ul>
          </ScrollArea>
        </section>
      </DialogContent>
    </Dialog>
  )
}
