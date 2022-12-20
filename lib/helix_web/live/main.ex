defmodule HelixWeb.MainLive do
  use HelixWeb, :live_view

  alias Helix.Graph

  require UUID

  @impl true
  def mount(_params, _session, socket) do

    graphs = Graph.list_local_graphs()

    if connected?(socket) do
      HelixWeb.Endpoint.subscribe("LiveModule")
    end

    {:ok, assign(socket,
        page_title: "Helix",
        selected_graph: graphs |> List.first(),
        graphs: graphs,
        graph_preview: Graph.load_and_render_template(graphs |> List.first()),
        started: false,
        all_events: [],
        load_error: nil,
        loaded_graph_name: "",
        input_targets: [],
        message: ""
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
    try do
      {nodes, graph} = Graph.load_graph(socket.assigns.selected_graph)
      input_targets = Enum.reduce(nodes, [], fn i, acc ->
        {key, node} = i
        name = key |> List.first()
        if Map.get(node.attrs, "module") == "LiveInputModule" do
          acc ++ [name]
        else
          acc
        end
      end)
      {:noreply, assign(socket,
        started: true,
        load_error: nil,
        loaded_graph_name: Map.keys(graph) |> List.first(),
        page_title: Map.keys(graph) |> List.first(),
        input_targets: input_targets
      )}
    catch
      _k, e ->
        {:noreply, assign(socket,
            started: false,
            load_error: e.message
        )}
    end
  end

  @impl true
  def handle_event("submit_message", %{"input" => %{"message" => message, "target" => target}}, socket) do

    target_pid = :ets.lookup(:pids, target) |> Enum.at(0) |> elem(1)
    event = %{
      type: :text,
      value: message,
      source_id: "LiveInputForm",
      message_id: UUID.uuid4(),
      timestamp: :os.system_time(:milli_seconds)
    }
    GenServer.cast(target_pid, {:convey, event})

    {
      :noreply, assign(socket,
      all_events: socket.assigns.all_events ++ [event],
      message: ""
    )}
  end

  def handle_event("message_updated", %{"input" => %{"message" => message, "target" => target}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  ##
  # From Task Modules
  ##

  @impl true
  def handle_info(%{event: "convey", payload: event}, socket) do
    {:noreply,
      socket
      |> assign(all_events: socket.assigns.all_events ++ [event])
      |> push_event("scrollbox", %{scrollbox: true})
    }
  end

end
