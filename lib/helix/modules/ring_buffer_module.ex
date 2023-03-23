defmodule Helix.Modules.RingBufferModule do

  use Helix.Modules.Module
  alias RingBuffer

  def init(state) do
    rb_size = String.to_integer(Map.get(state, :size, "10"))
    buffer = RingBuffer.new(rb_size)
    new_state = Map.put(state, :buffer, buffer)
    {:ok, new_state }
  end

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    new_buffer = RingBuffer.put(state.buffer, event.value)
    new_state = Map.put(state, :buffer, new_buffer)
    if new_buffer.evicted != nil do
      output_state = convey(new_buffer.evicted, new_state)
      {:noreply, output_state}
    else
      {:noreply, new_state}
    end

  end

end
