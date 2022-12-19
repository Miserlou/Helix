defmodule Helix.Modules.Module do
  use GenServer

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

      def convey(value, targets) do
        for target <- targets do
          event = %{
            type: :text,
            value: value
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

      defoverridable [init: 1]

    end
  end
end
