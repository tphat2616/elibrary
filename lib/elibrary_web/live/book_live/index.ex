defmodule ElibraryWeb.BookLive.Index do
  use ElibraryWeb, :live_view

  alias Elibrary.Book
  alias Elibrary.BookService

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:books, BookService.list_books())
     |> assign(
       :sum_records,
       Number.Delimit.number_to_delimited(BookService.sum_records(), precision: 0)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Tag")
    |> assign(:book, BookService.get_book!(elem(Integer.parse(id), 0)))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing books")
    |> assign(:book, nil)
  end
end
