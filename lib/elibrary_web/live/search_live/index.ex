defmodule ElibraryWeb.SearchLive.Index do
  use ElibraryWeb, :live_view

  alias Elibrary.LabelService

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:labels, [])
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"query" => %{"query" => key_query}} = _query_params, socket) do
    labels = LabelService.search_label(key_query)
    {:noreply, assign(socket, :labels, labels)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing labels")
  end
end
