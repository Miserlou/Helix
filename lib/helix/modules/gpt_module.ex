defmodule Helix.Modules.GPTModule do

  use Helix.Modules.Module

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

    convey(value, state)
    {:noreply, state}
  end

  ##
  # GPT Utils
  ##

  defp extract_result(res) do
    res |> Map.get(:choices) |> Enum.at(0) |> Map.get("text") |> String.trim
  end

  def find_substitutions(text) do
    # I am bad at Regex. This is from here: https://stackoverflow.com/a/44257681
    Regex.scan(~r/[^{\}]+(?=})/, text)
    |> List.flatten()
  end

  def replace_id_with_value(prompt, id_index, history) do
    {id, index} = if String.contains?(id_index, ".") do
      split_s = String.split(id_index, ".")
      {id, index_s} = {Enum.at(split_s, 0), Enum.at(split_s, 1)}
      {id, String.to_integer(index_s)}
    else
      {id_index, 0}
    end

    event = Enum.at(history, length(history) - index - 1, %{value: ""})
    String.replace(prompt, id, event.value)
  end

  def update_prompt(state) do
    subs = find_substitutions(state.prompt)
    loaded_prompt = Enum.reduce(subs, state.prompt, fn id, prompt_acc ->
      replace_id_with_value(prompt_acc, id, Map.get(state.input_history, id, []))
    end)
    loaded_prompt
      |> String.replace("{", "")
      |> String.replace("}", "")
  end

end
