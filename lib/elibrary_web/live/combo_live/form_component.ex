defmodule ElibraryWeb.ComboLive.FormComponent do
  use ElibraryWeb, :live_component

  alias Elibrary.ComboService
  @impl true
  def update(%{combo: combo} = assigns, socket) do
    changeset = ComboService.change_combo(combo)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"combo" => combo_params}, socket) do
    changeset =
      socket.assigns.combo
      |> ComboService.change_combo(combo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"combo" => combo_params}, socket) do
    save_combo(socket, socket.assigns.action, combo_params)
  end

  defp save_combo(socket, :edit, combo_params) do
    case ComboService.update_combo(socket.assigns.combo, combo_params) do
      {:ok, _combo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Combo updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_combo(socket, :new, combo_params) do
    case ComboService.create_combo(combo_params) do
      {:ok, _combo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Combo created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
