defmodule HelixWeb.MainLive do
  use HelixWeb, :live_view

  alias Helix.Graph

  @impl true
  def mount(_params, _session, socket) do

    graphs = Graph.list_local_graphs()

    {:ok, assign(socket,
        page_title: "Helix",
        selected_graph: graphs |> List.first(),
        graphs: graphs,
        graph_preview: Graph.load_and_render(graphs |> List.first()),
        started: false
      )
    }
  end

  @impl true
  def handle_event("select_graph", %{"graph" => graph}, socket) do
    {:noreply, assign(socket,
        selected_graph: graph,
        graph_preiew: Graph.load_and_render(graph)
      )}
  end

  @impl true
  def handle_event("load_graph", _, socket) do
    Graph.load_graph(socket.assigns.selected_graph)
    {:noreply, assign(socket,
        started: true
    )}
  end

  @impl true
  def handle_event("send_message", %{"message" => message}, socket) do
    {:noreply, socket}
  end

end
