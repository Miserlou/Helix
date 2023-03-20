defmodule Helix.Modules.StartModule do

  use Helix.Modules.Module

  def init(state) do
    Process.send_after(self(), :start, String.to_integer(state.delay))
    {:ok, state}
  end

  def handle_info(:start, state) do
    ui_event(state)
    convey(state.message, state)
    {:noreply, state}
  end

  def handle_cast({:convey, _event}, state) do
    ui_event(state)
    {:noreply, state}
  end

end
