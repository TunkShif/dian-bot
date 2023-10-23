defmodule DianWeb.EventController do
  use DianWeb, :controller
  require Logger

  alias Dian.Messenger.{Event, MessageEventWorker}

  action_fallback DianWeb.FallbackController

  def create(conn, params) do
    with {:ok, event} <- Event.parse(params),
         job = MessageEventWorker.new(%{event: event, message: event.message}),
         {:ok, _job} <- Oban.insert(job) do
      conn
      |> put_status(:ok)
      |> json(%{data: nil, message: "Job enqueued."})
    else
      {:error, :unknown_event} ->
        conn |> put_status(:accepted) |> json(%{data: nil, message: "Skipped unknown event."})

      error ->
        error
    end
  end
end
