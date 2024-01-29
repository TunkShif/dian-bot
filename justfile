server-iex:
  cd server && iex -S mix phx.server

server-dev:
  cd server && mix phx.server

mock-dev:
  cd mock && bun dev
