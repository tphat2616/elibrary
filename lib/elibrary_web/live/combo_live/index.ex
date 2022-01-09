defmodule ElibraryWeb.ComboLive.Index do
  use ElibraryWeb, :live_view

  alias Elibrary.Combo
  alias Elibrary.ComboService

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:list_combo, ComboService.list_combo())
      |> assign(:sum_records, Number.Delimit.number_to_delimited(ComboService.sum_records(), precision: 0))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Combo")
    |> assign(:combo, %Combo{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Tag")
    |> assign(:combo, ComboService.get_combo!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Combo")
    |> assign(:combo, nil)
  end
end
