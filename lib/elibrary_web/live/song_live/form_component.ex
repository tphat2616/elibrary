defmodule ElibraryWeb.SongLive.FormComponent do
  use ElibraryWeb, :live_component

  alias Elibrary.SongService
  @impl true
  def update(%{song: song} = assigns, socket) do
    changeset = SongService.change_song(song)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"song" => song_params}, socket) do
    changeset =
      socket.assigns.song
      |> SongService.change_song(song_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"song" => song_params}, socket) do
    save_song(socket, socket.assigns.action, song_params)
  end

  defp save_song(socket, :edit, song_params) do
    case SongService.update_song(socket.assigns.song, song_params) do
      {:ok, _song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_song(socket, :new, song_params) do
    song_params |> IO.inspect()
    case SongService.create_song(song_params) do
      {:ok, _song} ->
        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
