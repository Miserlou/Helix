defmodule Helix.Graph do

  require Dotx
  require Solid

  def load_graph(path) do

    dot_string = load_and_render_template(path)
    {nodes, graph} = load_graph_from_dot_string(dot_string)

    instantiate_nodes(nodes)

    ## Start it off
    # ying_pid = :ets.lookup(:pids, "Ying") |> Enum.at(0) |> elem(1)
    # event = %{
    #   type: :text,
    #   value: "Hello"
    # }
    # GenServer.cast(ying_pid, {:convey, event})

    graph
  end

  def load_and_render_template(path) do
    contents = File.read!(path)
    {:ok, template} = Solid.parse(contents)
    Solid.render!(template, %{}) |> to_string |> String.trim()
  end

  def load_graph_from_dot_string(dot_s) do
    decoded_graph = Dotx.decode!(dot_s)
    Dotx.to_nodes(decoded_graph)
  end

  @spec instantiate_nodes(any) :: list
  def instantiate_nodes(nodes) do

    for {id, node} <- nodes do

      module = get_module_for_name(node.attrs["module"])

      initial_state = Map.drop(node.attrs, ["edges_from", "graph"])
        |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
        |> Map.put(:id, node.id |> Enum.at(0))
        |> Map.put(:targets, get_targets_for_node(node))

      {:ok, pid} = GenServer.start_link(module, initial_state)
      # {:ok, pid} = GenServer.start(module, initial_state)

      IO.inspect(Enum.at(id, 0) <> ": " <> inspect(pid))
      :ets.insert(:pids, {Enum.at(id, 0), pid})
    end
  end

  def get_module_for_name(name) do
    total_module_name = "Elixir.Helix.Modules." <> name
    String.to_existing_atom(total_module_name)
  end

  def get_targets_for_node(node) do
    Enum.map(node.attrs["edges_from"], fn (x) ->
      Enum.at(x.to.id, 0)
    end)
  end

  def list_local_graphs() do
    path = :code.priv_dir(:helix) |> Path.join("graphs") |> Path.join("*")
    Path.wildcard(path)
  end

end
