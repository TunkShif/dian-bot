export * from "./dian-service"
export * from "./messenger-service"
export * from "./statistics-service"
export * from "./user-service"

export type Data<T> = { data: T; message?: string; errors?: { detail: string } }
export type ListData<T> = Data<T[]>
export type PaginatedData<T> = Data<{ metadata: PaginationMetadata; entries: T[] }>
export type PaginationMetadata = {
  page_number: number
  page_size: number
  total_pages: number
  total_entries: number
}
