import { useUpdateSearchParams } from "@/components/hooks/use-update-search-params"
import { RequireAdmin } from "@/components/shared/require-admin"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuPortal,
  DropdownMenuTrigger
} from "@/components/ui/dropdown-menu"
import { MoreHorizontalIcon, ShareIcon, Trash2Icon } from "lucide-react"
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
            <span>
              分享
            </span>
          </DropdownMenuItem>
          <RequireAdmin>
            <DropdownMenuItem onSelect={() => updateSearchParams(params => params.set("delete", id.toString()))}>
              <Trash2Icon className="w-4 h-4 mr-2 text-rose-500" />
              <span className="text-rose-500">
                删除
              </span>
            </DropdownMenuItem>
          </RequireAdmin>
        </DropdownMenuContent>
      </DropdownMenuPortal>
    </DropdownMenu>
  )
}
