defmodule Helix.Modules.GPTModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    {:ok, res} = OpenAI.completions(
      Map.get(state, :model, "text-davinci-003"),
      prompt: "You are a homunculous. Respond with a thought. Your input is:" <> event.value,
      max_tokens: String.to_integer(Map.get(state, :max_tokens, "200")),
      temperature: String.to_float(Map.get(state, :temperature, "0.8"))
    )

    value = extract_result(res)

    convey(value, state)
    {:noreply, state}
  end

  defp extract_result(res) do
    res |> Map.get(:choices) |> Enum.at(0) |> Map.get("text") |> String.trim
  end

end
