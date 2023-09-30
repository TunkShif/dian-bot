import { cn } from "@/utils/styling"
import React from "react"

export const Spinner = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div
      ref={ref}
      role="status"
      aria-label="loading"
      className={cn(
        "animate-spin inline-block w-5 h-5 border-[3px] border-current border-t-transparent text-primary rounded-full",
        className
      )}
      {...props}
    >
      <span className="sr-only">Loading...</span>
    </div>
  )
)
Spinner.displayName = "Spinner"

export const LoadingSpinner: React.FC<{ className?: string }> = ({ className }) => (
  <div className={cn("flex justify-center items-center py-6 gap-3", className)}>
    <Spinner /> <span className="text-sm">Loading...</span>
  </div>
)
