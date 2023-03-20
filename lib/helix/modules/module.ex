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

      def convey(value, state) do

        sent_events = Enum.reduce(state.targets, [], fn target, event_acc ->
          event = %{
            type: :text,
            value: value,
            source_id: state.id,
            message_id: UUID.uuid4(),
            timestamp: :os.system_time(:milli_seconds)
          }
          GenServer.cast(get_pid_for_name(target), {:convey, event})
          event_acc ++ [event]
        end )
        %{state | output_history: state.output_history ++ [sent_events], input_sources: Map.new(state.input_sources, fn {k, _v} -> {k, nil} end)}
      end

      def convey_img(value, state) do

        sent_events = Enum.reduce(state.targets, [], fn target, event_acc ->
          event = %{
            type: :img,
            value: value,
            source_id: state.id,
            message_id: UUID.uuid4(),
            timestamp: :os.system_time(:milli_seconds)
          }
          GenServer.cast(get_pid_for_name(target), {:convey, event})
          event_acc ++ [event]
        end )
        %{state | output_history: state.output_history ++ [sent_events], input_sources: Map.new(state.input_sources, fn {k, _v} -> {k, nil} end)}
      end

      def ui_event(state, type \\ :flash, data \\ nil) do
        AistudioWeb.Endpoint.broadcast(
          "LiveModule",
          "ui_event",
          %{
            type: type,
            data: data,
            node_id: state[:ui_node_id]
          }
        )

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
        updated_input_sources = Map.put(state.input_sources, event.source_id, event)
        %{state | input_history: updated_input_history, last_input: event, input_sources: updated_input_sources}
      end

      def create_error_event(error, source_id) do
        event = %{
          type: :error,
          value: Kernel.inspect(error),
          source_id: source_id,
          message_id: UUID.uuid4(),
          timestamp: :os.system_time(:milli_seconds)
        }
      end

      defoverridable [init: 1]

    end
  end
end
