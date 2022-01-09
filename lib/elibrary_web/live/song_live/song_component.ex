defmodule ElibraryWeb.SongLive.SongComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @song.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/music.png" class="post-avatar"/>
        </div>
        <h4 class="title-name"><b><%= @song.name %></b></h4>
      </div>
      <div class="row description">
        <div class="column column-90 post-body">
          <%= if @song.description != nil do %>
            <span><%= @song.description %></span>
          <% else %>
            <span>...</span>
          <% end %>
        </div>
      </div>
    
      <div class="row">
        <div class="label_tag">
        <%= live_patch to: Routes.song_index_path(@socket, :edit, @song.id) do %>
          <img style="height: 30px" src="/images/tag.png" class="icon-img"/>
        <% end %>
        <b><%= @song.label_name %></b>
        </div>
      </div>
    </div>
    """
  end
end
