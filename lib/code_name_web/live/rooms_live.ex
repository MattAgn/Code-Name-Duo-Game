defmodule CodeNameWeb.RoomsLive do
  use CodeNameWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("create-room", _, socket) do
    room_token =
      RandomStringGenerator.generate("LLLllllddddd")
      |> RandomStringGenerator.shuffle()

    socket = assign(socket, room_token: room_token)

    {:noreply, socket}
  end
end
