defmodule ElibraryWeb.BookLive.BookComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @book.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/book.png" class="post-avatar"/>
        </div>
        <h4 class="title-name"><b><%= @book.name %></b></h4>
      </div>
      <div class="row description">
        <div class="column column-90 post-body">
          <%= if @book.description != nil do %>
            <span><%= @book.description %></span>
          <% else %>
            <span>...</span>
          <% end %>
        </div>
      </div>
    
      <div class="row">
        <div class="label_tag">
        <%= live_patch to: Routes.book_index_path(@socket, :edit, @book.id) do %>
          <img style="height: 30px" src="/images/tag.png" class="icon-img"/>
        <% end %>
        <b><%= @book.label_name %></b>
        </div>
      </div>
    </div>
    """
  end
end
