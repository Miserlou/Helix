defmodule Helix.Modules.KeyValueStoreModule do

  alias JSON
  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  @spec handle_cast({:convey, atom | %{:source_id => binary, optional(any) => any}}, %{
          :input_history => map,
          :input_sources => map,
          :last_input => any,
          optional(any) => any
        }) :: {:noreply, %{:input_sources => map, optional(any) => any}}
  def handle_cast({:convey, event}, state) do
    ui_event(state)
    state = update_input_history(state, event)

    gets = String.split(Map.get(state, :Get, ""), ",")
    get_alls = String.split(Map.get(state, :GetAll, ""), ",")
    source = String.replace(event.source_id, "_" <> state.graph_id, "")
    default = "nil"
    kv = Map.get(state, :kv, %{})

    cond do
      Enum.member?(gets, source) ->
        {:noreply, convey(Map.get(kv, event.value, default), state)}

      Enum.member?(get_alls, source) ->
        {:noreply, convey(JSON.encode!(kv), state)}

      true ->
        kv_u = Enum.reduce(String.split(event.value, "\n"), kv, fn line, acc ->
          if String.contains?(line, ": ") do
            split = String.split(line, ": ")
            key = Enum.at(split, 0)
            value = Enum.at(split, 1)
            Map.put(acc, key, value)
          else
            acc
          end
        end)
        {:noreply, Map.put(state, :kv, kv_u)}

    end
  end
end
