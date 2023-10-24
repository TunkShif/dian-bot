import { Button } from "@/components/ui/button"
import { Loader2Icon } from "lucide-react"
import React from "react"
import { useNavigation } from "react-router-dom"

export const SubmitButton: React.FC<React.ComponentPropsWithoutRef<typeof Button>> = ({
  children,
  ...rest
}) => {
  const navigation = useNavigation()

  const isSubmitting = navigation.state === "submitting"

  return (
    <Button {...rest} type="submit" disabled={isSubmitting}>
      <div className="mr-2" hidden={!isSubmitting} aria-hidden={!isSubmitting}>
        <Loader2Icon className="h-4 w-4 animate-spin" />
      </div>
      {children}
    </Button>
  )
}
