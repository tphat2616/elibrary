defmodule ElibraryWeb.SongLive.Index do
  use ElibraryWeb, :live_view

  alias Elibrary.Song
  alias Elibrary.SongService

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:songs, SongService.list_songs())
     |> assign(
       :sum_records,
       Number.Delimit.number_to_delimited(SongService.sum_records(), precision: 0)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Song")
    |> assign(:song, %Song{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Tag")
    |> assign(:song, SongService.get_song!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Songs")
    |> assign(:song, nil)
  end
end
