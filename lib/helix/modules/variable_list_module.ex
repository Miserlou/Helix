defmodule Helix.Modules.VariableListModule do

    use Helix.Modules.Module

    def init(state) do
      list = list_from_string(state.default)
      sstate = Map.put(state, :list, list)
      sstate = Map.put(sstate, :index, 0)
      {:ok, sstate}
    end

    def handle_cast({:convey, event}, state) do
      ui_event(state)
      state = update_input_history(state, event)

      append_sets = String.split(Map.get(state, :Append, ""), ",")
      iterate_sets = String.split(Map.get(state, :Iterate, ""), ",")
      getall_sets = String.split(Map.get(state, :GetAll, ""), ",")
      source = String.replace(event.source_id, "_" <> state.graph_id, "")

      cond do
        Enum.member?(append_sets, source) ->
          # Append
          ustate = Map.put(state, :list, Map.get(state, :list) ++ [event.value])
          {:noreply, ustate}

        Enum.member?(getall_sets, source) ->
          # Get All
          ilist = Kernel.inspect(Map.get(state, :list))
          {:noreply, convey(ilist, state)}

        Enum.member?(iterate_sets, source) ->
            # Get Value and Increment
            index = Map.get(state, :index)
            list = Map.get(state, :list)

            index = if index + 1 > length(list) do
              0
            else
              index
            end

            val = Enum.at(list, index)
            nindex = index + 1
            nstate = Map.put(state, :index, nindex)

            {:noreply, convey(val, nstate)}

        true ->
          # Set the new list
          new_list = list_from_string(event.value)
          {:noreply, Map.put(state, :list, new_list)}

      end
    end

    def list_from_string(str) do

      l = cond do
        str == "" or str == nil ->
          []

        String.contains?(str, "\n") ->
            String.split(str, "\n", trim: true)

        String.contains?(str, ",") ->
            String.split(str, ",", trim: true)

        true ->
          [str]

      end

      Enum.reduce(l, [], fn i, acc ->
        acc ++ [String.trim(i)]
      end)

    end

  end
