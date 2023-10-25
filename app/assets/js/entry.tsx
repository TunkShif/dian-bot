import { ThemeProvider } from "@/components/theme"
import { Router } from "@/router"
import { queryClient } from "@/utils/client"
import { QueryClientProvider } from "@tanstack/react-query"
import { StrictMode } from "react"
import { createRoot } from "react-dom/client"
import { HelmetProvider } from "react-helmet-async"

const Root = () => {
  return (
    <StrictMode>
      <ThemeProvider>
        <QueryClientProvider client={queryClient}>
          <HelmetProvider>
            <Router />
          </HelmetProvider>
        </QueryClientProvider>
      </ThemeProvider>
    </StrictMode>
  )
}

export const mountApp = () => createRoot(document.getElementById("app")!).render(<Root />)

export const registerServiceWorker = () =>
  navigator.serviceWorker.register("/sw.js", { scope: "/" })
