defmodule ElibraryWeb.SearchLive.LabelComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @label.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/options.png" class="post-avatar"/>
        </div>
        <b><%= @label.name %></b>
      </div>
      <div class="row">
        <div class="column column-90 post-body">
          <%= if @label.description != nil do %>
            <b><%= @label.description %></b>
          <% else %>
            <b>...</b>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
