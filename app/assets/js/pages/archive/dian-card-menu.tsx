import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuPortal,
  DropdownMenuTrigger
} from "@/components/ui/dropdown-menu"
import { MoreHorizontalIcon, ShareIcon } from "lucide-react"
import React from "react"

export const DianCardMenu: React.FC<{ id: number }> = ({ id }) => {
  const updateSearchParams = useUpdateSearchParams()

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="icon">
          <MoreHorizontalIcon className="w-5 h-5" />
        </Button>
      </DropdownMenuTrigger>

      <DropdownMenuPortal>
        <DropdownMenuContent>
          <DropdownMenuItem
            onSelect={() => updateSearchParams((params) => params.set("share", id.toString()))}
          >
            <ShareIcon className="w-4 h-4 mr-2" />
            分享
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenuPortal>
    </DropdownMenu>
  )
}
