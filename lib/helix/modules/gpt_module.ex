defmodule Helix.Modules.GPTModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    state = update_input_history(state, event)
    prompt = update_prompt(state)
    :timer.sleep(String.to_integer(Map.get(state, :delay, "0")))

    case OpenAI.completions(
      Map.get(state, :model, "text-davinci-003"),
      prompt: prompt,
      max_tokens: String.to_integer(Map.get(state, :max_tokens, "2048")),
      temperature: String.to_float(Map.get(state, :temperature, "0.8"))
    ) do
      {:ok, res} ->
        value = extract_result(res)
        output_state = convey(value, state)
        {:noreply, output_state}
      {:error, :timeout} ->
        # XXX TODO: Handle properly
        IO.inspect("XXX: Timeout error")
        {:noreply, state}
      {:error, e} ->
        IO.inspect("Unexpcected error: " <> Kernel.inspect(e))
        {:noreply, state}
    end
  end
end
