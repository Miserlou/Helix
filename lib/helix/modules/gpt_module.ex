defmodule Helix.Modules.GPTModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    state = update_input_history(state, event)
    prompt = update_prompt(state)
    :timer.sleep(String.to_integer(Map.get(state, :delay, "0")))

    {:ok, res} = OpenAI.completions(
      Map.get(state, :model, "text-davinci-003"),
      prompt: prompt,
      max_tokens: String.to_integer(Map.get(state, :max_tokens, "1000")),
      temperature: String.to_float(Map.get(state, :temperature, "0.8"))
    )

    value = extract_result(res)

    convey(value, state)
    {:noreply, state}
  end

end
