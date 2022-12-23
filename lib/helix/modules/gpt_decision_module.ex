defmodule Helix.Modules.GPTDecisionModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    state = update_input_history(state, event)
    prompt = update_prompt(state)
    :timer.sleep(String.to_integer(Map.get(state, :delay, "0")))

    {:ok, res} = OpenAI.completions(
      Map.get(state, :model, "text-davinci-003"),
      prompt: prompt,
      max_tokens: String.to_integer(Map.get(state, :max_tokens, "200")),
      temperature: String.to_float(Map.get(state, :temperature, "0.8"))
    )
    value = extract_result(res)

    if String.contains?(value, Map.get(state, :decider, "YES")) do
      {:noreply, convey(state.last_input.value, state)}
    else
      {:noreply, state}
    end
  end

end
