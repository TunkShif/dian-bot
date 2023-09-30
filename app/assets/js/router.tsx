import {
  Route,
  RouterProvider,
  createBrowserRouter,
  createRoutesFromElements,
  redirect
} from "react-router-dom"

import { Archive, archiveLoader } from "@/pages/archive/page"
import { Dashboard, dashboardLoder } from "@/pages/dashboard/page"
import { Root } from "@/pages/root"

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" element={<Root />}>
      <Route index loader={() => redirect("/dashboard")} />
      <Route path="dashboard" element={<Dashboard />} loader={dashboardLoder} />
      <Route path="archive" element={<Archive />} loader={archiveLoader} />
    </Route>
  )
)

export const Router = () => {
  return <RouterProvider router={router} />
}
