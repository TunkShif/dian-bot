export * from "./dian-service"
export * from "./messenger-service"
export * from "./statistics-service"

export type Data<T> = { data: T }
export type ListData<T> = { data: T[] }
export type PaginatedData<T> = { data: { metadata: PaginationMetadata; entries: T[] } }
export type PaginationMetadata = {
  page_number: number
  page_size: number
  total_pages: number
  total_entries: number
}
