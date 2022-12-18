defmodule HelixWeb.MainLive do
  use HelixWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
        page_title: "Helix",
        graphs: %{}
      )
    }
  end

  @impl true
  def handle_event("load_graph", %{"graph" => graph}, socket) do
    {:noreply, socket}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    {:noreply, socket}
  end

end
