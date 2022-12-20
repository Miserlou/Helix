defmodule HelixWeb.HelixComponents do
  use Phoenix.Component
  alias Phoenix.HTML
  alias ColourHash

  def render_event(assigns) do

    %{type: type, value: value, source_id: source_id, message_id: message_id, timestamp: timestamp} = assigns.event

    ~H"""
    <%= if type == :text do %>

    <div id={message_id} class="grid grid-cols-10 items-center mt-1 lg:mt-3">
      <div class="col-span-1">
      </div>
      <div class="col-span-8">
        <div class="border bg-base-200 mb-1 rounded-lg shadow-md rounded-md p-2" style={"border-color: #" <> colorize(source_id)}>
          <%= Phoenix.HTML.raw(value) %>
        </div>
        <div class="text-xs mb-2" style={"color: #" <> colorize(source_id)}>
          <div class="flex justify-between w-full">
            <div class="">
              <b><i><%= source_id %></i></b>
            </div>
            <div class="">
              <span class="text-thin text-right opacity-50">
                <%= DateTime.from_unix!(timestamp, :millisecond) |> Calendar.strftime("%I:%M:%S")%>
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-span-1">
      </div>
    </div>

    <% end %>
    """

    # <%= if type == :host do %>
    # <div id={uuid} class="grid grid-cols-10 items-top mt-1 lg:mt-3">
    #   <div class="col-span-1 mx-1">
    #     <img class="fight-avatar ml-auto p-half" src={ user.avatar_url } title={ user.username } alt={ user.username }>
    #   </div>
    #   <div class="col-span-6">
    #     <div class="fight-bubble fight-bubble-red">
    #     <%= Phoenix.HTML.raw(message) %>
    #     </div>
    #   </div>
    #   <div class="col-span-1">
    #   </div>
    #   <div class="col-span-2">
    #   </div>
    # </div>
    # <% end %>

    # <%= if type == :challenger do %>

    # <div id={uuid} class="grid grid-cols-10 items-top mt-1 lg:mt-3">
    #   <div class="col-span-1">
    #   </div>
    #   <div class="col-span-2">
    #   </div>
    #   <div class="col-span-6">
    #     <div class="fight-bubble fight-bubble-blue text-right">
    #     <%= Phoenix.HTML.raw(message) %>
    #     </div>
    #   </div>
    #   <div class="col-span-1 mx-1">
    #     <img class="fight-avatar mr-auto p-half" src={user.avatar_url} alt={user.username}>
    #   </div>
    # </div>

    # <% end %>

    # <%= if type == :observer do %>

    # <div id={uuid} class="grid grid-cols-10 items-top mt-1 lg:mt-3">
    #   <div class="col-span-1">
    #   </div>
    #   <div class="col-span-2">
    #   </div>
    #   <div class="col-span-6">
    #     <div class="fight-bubble fight-bubble-gray">
    #     <%= Phoenix.HTML.raw(message) %>
    #     </div>
    #   </div>
    #   <div class="col-span-1 mx-1">
    #     <img class="fight-avatar ml-auto p-half" src={user.avatar_url} alt={user.username}>
    #   </div>
    # </div>

    # <% end %>

  end

  defp colorize(text) do
    ColourHash.hex(text, lightness: [0.5, 0.9], saturation: [0.4, 0.9])
  end

end
