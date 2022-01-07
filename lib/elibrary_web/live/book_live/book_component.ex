defmodule ElibraryWeb.BookLive.BookComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @book.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/book.png" class="post-avatar"/>
        </div>
        <b><%= @book.name %></b>
      </div>
      <div class="row">
        <div class="column column-90 post-body">
          <%= if @book.description != nil do %>
            <b><%= @book.description %></b>
          <% else %>
            <b>...</b>
          <% end %>
        </div>
      </div>

      <div class="row">
        <div class="column tweet-button-column">
        <%= live_patch to: Routes.book_index_path(@socket, :edit, @book.id) do %>
          <img style="height: 30px" src="/images/tag.png" class="icon-img"/>
        <% end %>
        </div>
      </div>
    </div>
    """
  end

  # def handle_event("retweet", _, socket) do
  #   Timeline.increase_retweets_count(socket.assigns.tweet)
  #   {:noreply, socket}
  # end
end
