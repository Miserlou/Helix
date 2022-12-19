defmodule HelixWeb.MainLive do
  use HelixWeb, :live_view

  alias Helix.Graph

  @impl true
  def mount(_params, _session, socket) do

    graphs = Graph.list_local_graphs()

    if connected?(socket) do
      HelixWeb.Endpoint.subscribe("LiveModule")
      # PubSub.subscribe(Helix.PubSub, "LiveModule")
    end

    {:ok, assign(socket,
        page_title: "Helix",
        selected_graph: graphs |> List.first(),
        graphs: graphs,
        graph_preview: Graph.load_and_render_template(graphs |> List.first()),
        started: false,
        events: []
      )
    }
  end

  @impl true
  def handle_event("select_graph", %{"graph" => graph}, socket) do
    {:noreply, assign(socket,
        selected_graph: graph,
        graph_preview: Graph.load_and_render_template(graph)
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

  ##
  # From Task Modules
  ##

  @impl true
  def handle_info(%{event: "convey", payload: event}, socket) do
    {:noreply,
      socket
      |> assign(events: socket.assigns.events ++ [event])
      |> push_event("scrollbox", %{scrollbox: true})
    }
  end

end
