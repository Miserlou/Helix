defmodule Helix.Graph do

  require Dotx
  require OpenAI

  def load_graph() do

    dot_string = """
digraph D {
  Ying [module=PassthroughModule]
  Yang [module=PassthroughModule]
  Print [module=PassthroughModule]

  Ying -> Yang [style=dashed, color=grey]
  Yang -> Ying [color="black:invis:black"]
  Yang -> Print
}
"""

    decoded_graph = Dotx.decode!(dot_string)
    {nodes, graph} = Dotx.to_nodes(decoded_graph)

    # res = OpenAI.completions(
    #   "text-davinci-003",
    #   prompt: "Mirror mirror, who is the fairest of them all?",
    #   max_tokens: 200,
    #   temperature: 0.8
    # )

    instantiate_nodes(nodes)

    ## Start it off
    ying_pid = :ets.lookup(:pids, "Ying") |> Enum.at(0) |> elem(1)
    event = %{
      type: :text,
      value: "Hello"
    }
    GenServer.cast(ying_pid, {:convey, event})

    graph
  end

  def instantiate_nodes(nodes) do

    for {id, node} <- nodes do
      module = get_module_for_name(node.attrs["module"])

      initial_state = %{
        targets: get_targets_for_node(node)
      }
      {:ok, pid} = GenServer.start_link(module, initial_state)

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

end
