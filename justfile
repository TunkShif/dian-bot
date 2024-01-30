server-iex:
  cd server && iex -S mix phx.server

server-dev:
  cd server && mix phx.server

webapp-dev:
  cd webapp && pnpm dev

mock-dev:
  cd mock && bun dev
