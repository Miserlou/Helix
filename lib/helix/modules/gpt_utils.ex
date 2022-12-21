defmodule Helix.Modules.GPTUtils do

  def extract_result(res) do
    res |> Map.get(:choices) |> Enum.at(0) |> Map.get("text") |> String.trim
  end

  def find_substitutions(text) do
    # I am bad at Regex. This is from here: https://stackoverflow.com/a/44257681
    Regex.scan(~r/[^{\}]+(?=})/, text)
    |> List.flatten()
  end

  def replace_id_with_value(prompt, id_index, history, state) do
    {id, index} = if String.contains?(id_index, ".") do
      split_s = String.split(id_index, ".")
      {id, index_s} = {Enum.at(split_s, 0), Enum.at(split_s, 1)}
      {id, String.to_integer(index_s)}
    else
      {id_index, 0}
    end

    cond do
      id == "INPUT" ->
        String.replace(prompt, id, state.last_input.value)
      id == "HISTORY" ->
        generate_history(state)
      true ->
        event = Enum.at(history, length(history) - index - 1, %{value: ""})
        String.replace(prompt, id, event.value)
    end
  end

  def update_prompt(state) do
    subs = find_substitutions(state.prompt)
    loaded_prompt = Enum.reduce(subs, state.prompt, fn id, prompt_acc ->
      replace_id_with_value(prompt_acc, id, Map.get(state.input_history, id, []), state)
    end)
    loaded_prompt
      |> String.replace("{", "")
      |> String.replace("}", "")
  end

  def generate_history(state) do
    unordered_events = Map.values(state.input_history) |> List.flatten()
    all_events = unordered_events ++ state.output_history |> List.flatten()
    sorted_events = Enum.sort_by(all_events, &Map.fetch(&1, :timestamp))
    Enum.reduce(sorted_events, "", fn event, string_acc ->
      string_acc <> event.source_id <> ": " <> event.value <> "\n\n"
    end)
  end

end
