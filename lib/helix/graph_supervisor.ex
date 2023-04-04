defmodule Helix.GraphSupervisor do
  use DynamicSupervisor

  def start_link(arg),
    do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def init(_arg),
    do: DynamicSupervisor.init(strategy: :one_for_one)

  def start_node(id, node_type, state) do

    child_spec = %{
      id: "#{state.id}_#{state.graph_id}",
      start: {node_type, :start_link, [state]}
    }
    DynamicSupervisor.start_child(id, child_spec)
  end
end
