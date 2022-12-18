defmodule Helix.Modules.GPTModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    {:ok, res} = OpenAI.completions(
      "text-davinci-003",
      prompt: "You are a homunculous. Respond with a thought. Your input is:" <> event.value,
      max_tokens: 200,
      temperature: 0.8
    )

    value = extract_result(res)

    convey(value, state.targets)
    {:noreply, state}
  end

  defp extract_result(res) do
    res |> Map.get(:choices) |> Enum.at(0) |> Map.get("text") |> String.trim
  end

end
