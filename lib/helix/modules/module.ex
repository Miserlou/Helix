defmodule Helix.Modules.Module do
  use GenServer

  require UUID

  defmacro __using__(_) do
    quote do
      @behaviour Module

      ##
      # Client API
      ##
      @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
      def start_link(_) do
        GenServer.start_link(__MODULE__, %{})
      end

      ##
      # Server API
      ##
      def init(state) do
        {:ok, state}
      end

      # def handle_cast({:convey, event}, state) do
      #   convey_to_targets("Test", state.targets)
      #   {:noreply, state}
      # end

      def convey(value, state) do
        for target <- state.targets do
          event = %{
            type: :text,
            value: value,
            source_id: state.id,
            message_id: UUID.uuid4(),
            timestamp: :os.system_time(:milli_seconds)
          }
          GenServer.cast(get_pid_for_name(target), {:convey, event})
        end
      end

      ##
      # Utilities
      ##
      def get_pid_for_name(name) do
        pid = :ets.lookup(:pids, name) |> Enum.at(0) |> elem(1)
        pid
      end

      def update_input_history(state, event) do
        input_history_for_source = Map.get(state.input_history, event.source_id, [])
        updated_input_history_for_source = input_history_for_source ++ [event]
        updated_input_history = Map.put(state.input_history, event.source_id, updated_input_history_for_source)
        %{state | input_history: updated_input_history}
      end

      defoverridable [init: 1]

    end
  end
end
