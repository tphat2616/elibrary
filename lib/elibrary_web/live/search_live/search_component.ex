defmodule ElibraryWeb.SearchLive.SearchComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @label.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/options.png" class="post-avatar"/>
        </div>
        <h4 class="title-name"><b><%= @label.name %></b></h4>
      </div>
      <div class="row description">
        <div class="column column-90 post-body">
          <%= if @label.description != nil do %>
            <span><%= @label.description %></span>
          <% else %>
            <span>...</span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
