alias Helix.Graph

defmodule Commandline.CLI do
  def main(args) do
    options = [switches: [file: :string],aliases: [f: :file]]
    {opts, _, _} = OptionParser.parse(args, options)

    {nodes, _, dspid} = Graph.load_graph(opts[:file], true)
    has_input = Graph.has_live_input?(nodes)
    input_targets = Enum.reduce(nodes, [], fn i, acc ->
      {key, node} = i
      name = key |> List.first()
      IO.inspect(Map.get(node.attrs, "module"))
      if Map.get(node.attrs, "module") == "ConsoleInputModule" do
        acc ++ [name]
      else
        acc
      end
    end)

    get_input(dspid, input_targets)

  end

  def get_input(dspid, input_targets) do

    message = IO.gets("?) ")
    send_input(message, input_targets)
    if Process.alive?(dspid) do
      get_input(dspid, input_targets)
    else
      IO.inspect("Goodbye.")
    end

  end

  def send_input(message, input_targets) do
    Enum.map(input_targets, fn target ->
      target_pid = :ets.lookup(:pids, target) |> Enum.at(0) |> elem(1)
      event = %{
        type: :text,
        value: message,
        source_id: "You:" <> target,
        message_id: UUID.uuid4(),
        timestamp: :os.system_time(:milli_seconds)
      }
      GenServer.cast(target_pid, {:convey, event})
    end)
  end

end
