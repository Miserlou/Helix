defmodule Helix.Modules.ClockModule do

  use Helix.Modules.Module

  def init(state) do
    Process.send_after(self(), :start, String.to_integer(state.delay))
    {:ok, state}
  end

  def handle_info(:start, state) do
    convey("Tick #{:os.system_time(:millisecond)}", state)
    ui_event(state)
    Process.send_after(self(), :start, String.to_integer(state.every))
    {:noreply, state}
  end

  def handle_cast({:convey, _event}, state) do
    ui_event(state)
    {:noreply, state}
  end

end
