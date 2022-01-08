defmodule ElibraryWeb.LabelLive.Index do
  use ElibraryWeb, :live_view

  alias Elibrary.LabelService

  @impl true
  def mount(_params, _session, socket) do
    labels = LabelService.list_top_10_label_used_most()
    {:ok,
     socket
     |> assign(:labels, labels)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing labels")
  end

end
