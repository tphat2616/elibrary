defmodule ElibraryWeb.SongLive.SongComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @song.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/music.png" class="post-avatar"/>
        </div>
        <b><%= @song.name %></b>
      </div>
      <div class="row">
        <div class="column column-90 post-body">
          <%= if @song.description != nil do %>
            <b><%= @song.description %></b>
          <% else %>
            <b>...</b>
          <% end %>
        </div>
      </div>

      <div class="row">
        <div class="column">
        <%= live_patch to: Routes.song_index_path(@socket, :edit, @song.id) do %>
          <img style="height: 30px" src="/images/tag.png" class="icon-img"/>
        <% end %>
        </div>
      </div>
    </div>
    """
  end
end
