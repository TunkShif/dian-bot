import { ThemeProvider } from "@/components/theme"
import { Router } from "@/router"
import { queryClient } from "@/utils/client"
import { QueryClientProvider } from "@tanstack/react-query"
import { StrictMode } from "react"
import { createRoot } from "react-dom/client"

const Root = () => {
  return (
    <StrictMode>
      <ThemeProvider>
        <QueryClientProvider client={queryClient}>
          <Router />
        </QueryClientProvider>
      </ThemeProvider>
    </StrictMode>
  )
}

export const mountApp = () => createRoot(document.getElementById("app")!).render(<Root />)
