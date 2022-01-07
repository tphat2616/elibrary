defmodule ElibraryWeb.BookLive.Index do
  use ElibraryWeb, :live_view

  alias Elibrary.Book
  alias Elibrary.BookService

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :books, BookService.list_books())}
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
    |> assign(:book, BookService.get_book!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing books")
    |> assign(:book, nil)
  end

  # @impl true
  # def handle_info({:tweet_created, _tweet}, socket) do
  #   page = Timeline.paginate_tweets()
  #   {:noreply, assign(socket, tweets: page.entries)}
  # end

  # @impl true
  # def handle_info({:tweet_updated, _tweet}, socket) do
  #   page = Timeline.paginate_tweets()
  #   {:noreply, assign(socket, tweets: page.entries)}
  # end
end
