defmodule Helix.Graph do

  require Dotx
  require Solid
  alias Helix.GraphSupervisor

  def load_graph(path, local \\ false) do

    dot_string = load_and_render_template(path)
    dot_string = if local do
      dot_string
      |> String.replace("LiveInputModule", "ConsoleInputModule")
      |> String.replace("LiveOutputModule", "ConsoleOutputModule")
    else
      dot_string
    end
    {nodes, graph} = load_graph_from_dot_string(dot_string)
    dspid = instantiate_nodes(nodes)
    if !local do
      {nodes, graph}
    else
      {nodes, graph, dspid}
    end
  end

  def load_and_render_template(path) do
    try do
      contents = File.read!(path)
      {:ok, template} = Solid.parse(contents)
      Solid.render!(template, %{}) |> to_string |> String.trim()
    catch
      k, e ->
        Kernel.inspect(k) <> ": " <> Kernel.inspect(e)
    end
  end

  def load_graph_from_dot_string(dot_s, edges \\ false) do
    decoded_graph = Dotx.decode!(dot_s)
    if edges do
      Dotx.to_edges(decoded_graph)
    else
      Dotx.to_nodes(decoded_graph)
    end
  end

  @spec instantiate_nodes(any) :: list
  def instantiate_nodes(nodes, env \\ %{}, graph_id \\ nil) do

    gid = case graph_id do
      nil -> UUID.uuid4()
      _ -> graph_id
    end

    istates = for {id, node} <- nodes do
      module = get_module_for_name(node.attrs["module"])
      initial_state = Map.drop(node.attrs, ["edges_from", "graph"])
        |> Map.new(fn {k, v} -> {String.to_atom(k), v} end) # XXX: to_existing_atom badargs here, no idea why
        |> Map.put(:id, (node.id |> Enum.at(0)) <> "_#{gid}")
        |> Map.put(:targets, get_targets_for_node(node, gid))
        |> Map.put(:input_sources, %{})
        |> Map.put(:input_history, %{})
        |> Map.put(:output_history, [])
        |> Map.put(:last_input, nil)
        |> Map.put(:module_name, module)
        |> Map.put(:graph_id, gid)
    end

    # XXX: Okay, I know this has bad complexity, I don't care, I don't work for you.
    # PRs welcome.
    istates = Enum.reduce(istates, istates, fn state, new_states ->
      has_as_input =
        new_states
        |> Enum.filter(fn t -> Enum.member?(state.targets, t.id) end)
      Enum.map(new_states, fn jstate ->
        if Enum.member?(has_as_input, jstate), do: %{jstate | input_sources: Map.put(jstate.input_sources, state.id, nil)}, else: jstate end)
    end)

    # Sprinkle env
    istates = Enum.map(istates, fn state -> Map.merge(state, env) end)

    name_atom = String.to_atom("GraphSupervisor.#{gid}")
    {:ok, supervisor_pid} = DynamicSupervisor.start_link(GraphSupervisor, :no_args, name: name_atom)
    for state <- istates do
      try do
        # XXX https://thoughtbot.com/blog/how-to-start-processes-with-dynamic-names-in-elixir
        #{:ok, pid} = GenServer.start_link(state.module_name, state)
        {:ok, pid} = GraphSupervisor.start_node(name_atom, state.module_name, state)
        :ets.insert(:pids, {"#{state.id}", pid})
      catch
        x, y ->
          IO.inspect(x)
          IO.inspect(y)
      end
    end
    supervisor_pid
  end

  def get_module_for_name(name) do
    total_module_name = "Elixir.Helix.Modules." <> name
    String.to_existing_atom(total_module_name)
  end

  def get_targets_for_node(node, gid) do
    Enum.map(node.attrs["edges_from"], fn (x) ->
      Enum.at(x.to.id, 0) <> "_#{gid}"
    end)
  end

  @spec list_local_graphs :: [binary]
  def list_local_graphs() do
    path = :code.priv_dir(:helix) |> Path.join("graphs") |> Path.join("*")
    Path.wildcard(path)
  end

  def has_live_input?(nodes) do
    Enum.reduce(nodes, false, fn i, acc ->
      {key, node} = i
      if Map.get(node.attrs, "module") == "LiveInputModule" do
        true
      else
        acc
      end
    end)
  end

end
