defmodule ElibraryWeb.ComboLive.ComboComponent do
  use ElibraryWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @combo.id %>" class="book">
      <div class="row">
        <div class="column column-20">
          <img src="/images/combo.png" class="post-avatar"/>
        </div>
        <h4 class="title-name"><b><%= @combo.name %></b></h4>
      </div>
    
      <div class="row">
        <div class="label_tag">
        <%= live_patch to: Routes.combo_index_path(@socket, :edit, @combo.id) do %>
          <img style="height: 30px" src="/images/tag.png" class="icon-img"/>
        <% end %>
        <b><%= @combo.label_name %></b>
        </div>
      </div>
    </div>
    """
  end
end
