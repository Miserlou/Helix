defmodule Helix.Modules.HFImageModule do

    use Helix.Modules.Module
    alias HTTPoison
    alias Jason
    alias Base

    def handle_cast({:convey, event}, state) do
      ui_event(state)

      model = Map.get(state, :model, "")
      token = Map.get(state, :HF_INFERENCE_TOKEN, "hf_REPLACE_ME")
      url = "https://api-inference.huggingface.co/models/" <> model

      request = %HTTPoison.Request{
        method: :post,
        url: url,
        options: [:recv_timout, 30000],
        headers: [
          {~s|Authorization|, ~s|Bearer #{token}|},
          {~s|Content-Type|, ~s|application/json|},
        ],
        params: [],
        body: ~s|{"inputs": "#{event.value}"}|
      }

      case HTTPoison.request(request) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

          src = "data:image/png;base64," <> (body |> Base.encode64())

          output_state = convey_img(src, state)
          {:noreply, output_state}
        {:ok, %HTTPoison.Response{body: body}} ->
          broadcast_error(state, body)
          {:noreply, state}
        {:error, %HTTPoison.Error{} = error} ->
          broadcast_error(state, error)
          {:noreply, state}
      end

    end

  end
