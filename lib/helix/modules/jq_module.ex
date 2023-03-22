defmodule Helix.Modules.JQModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do

    jay = Map.get(state, :jq, "")
    case JQ.query(event.value, jay) do
      {:ok, res} ->
        {:noreply, convey(res, state)}
      {:error, err} ->
        AistudioWeb.Endpoint.broadcast(
          "LiveModule_#{state.graph_id}",
          "convey",
          create_error_event(err, state.id)
        )
        {:noreply, state}
    end
  end

end

defmodule JQ do
  @moduledoc """
  Provides capability to run jq queries on elixir structures.
  [jq docs](https://stedolan.github.io/jq/)
  ## Examples
      iex> JQ.query(%{key: "value"}, ".key")
      {:ok, "value"}
      iex> JQ.query!(%{key: "value"}, ".key")
      "value"
  """
  alias JQ.{MaxByteSizeExceededException, NoResultException, SystemCmdException, UnknownException}
  require Logger

  @default_options %{max_byte_size: nil}

  @doc ~S"""
  Execute a jq query on an elixir structure.
  Internally invokes `JQ.query!/3` and rescues from all exceptions.
  If a `JQ.NoResultException` is raised, `{:ok, nil}` is returned
  """
  def query(payload, query, options \\ [])

  @spec query(any(), String.t(), list()) ::
          {:ok, any()} | {:error, :cmd | :unknown | :max_byte_size_exceeded}
  def query(payload, query, options) do
    {:ok, query!(payload, query, options)}
  rescue
    _ in NoResultException ->
      {:ok, nil}

    e in [SystemCmdException, UnknownException] ->
      Logger.warn(e.message)
      {:error, e.message}

    e in MaxByteSizeExceededException ->
      Logger.warn(e.message)
      {:error, :max_byte_size_exceeded}

    error ->
      Logger.warn("unknown error. error: #{inspect(error)}")
      {:error, :unknown}
  end

  @doc ~S"""
  Execute a jq query on an elixir structure.
  * `payload` is any elixir structure
  * `query` a jq query as a string
  Internally this function encodes the `payload` into JSON, writes the JSON to
  a temporary file, invokes the jq executable on the temporary file with the supplied
  jq `query`.
  The result is then decoded from JSON back into an elixir structure.
  The temporary file is removed, regardless of the outcome. `System.cmd/3` is called
  with the `:stderr_to_stdout` option.
  ## Options
    * `:max_byte_size` - integer representing the maximum number of bytes allowed for the payload, defaults to `nil`.
  ## Error reasons
  * `JQ.MaxByteSizeExceededException` - when the byte_size of the encoded elixir structure is greater than the `:max_byte_size` value
  * `JQ.SystemCmdException` - when System.cmd/3 returns a non zero exit code
  * `JQ.NoResultException` - when no result was returned
  * `JQ.UnknownException` - when System.cmd/3 returns any other error besides those already handled
  * `Poison.EncodeError` - when there is an error encoding `payload`
  * `Poison.DecodeError` - when there is an error decoding the jq query result
  * `Temp.Error` - when there is an error creating a temporary file
  * `File.Error` - when there is an error removing a temporary file
  """
  def query!(payload, query, options \\ [])

  @spec query!(any(), String.t(), list()) :: any()
  def query!(payload, query, options) do
    %{max_byte_size: max_byte_size} = Enum.into(options, @default_options)

    #json = payload |> Poison.encode!() |> validate_max_byte_size(max_byte_size)
    json = payload |> validate_max_byte_size(max_byte_size)

    {fd, file_path} = Temp.open!()
    IO.write(fd, json)
    File.close(fd)

    try do
      case System.cmd("jq", [query, file_path], stderr_to_stdout: true) do
        {_, code} = error when is_integer(code) and code != 0 ->
          raise(SystemCmdException, result: error, command: "jq", args: [query, file_path])

        {value, code} when is_integer(code) and code == 0 ->
          #result = Poison.decode!(value)
          result = value
          unless result, do: raise(NoResultException)
          result

        error ->
          raise(UnknownException, error)
      end
    after
      File.rm!(file_path)
    end
  end

  defp validate_max_byte_size(json, max_byte_size)
       when is_integer(max_byte_size) and byte_size(json) > max_byte_size do
    raise(MaxByteSizeExceededException, size: byte_size(json), max_byte_size: max_byte_size)
  end

  defp validate_max_byte_size(json, _), do: json
end

defmodule JQ.SystemCmdException do
  defexception [:message]

  @impl true
  def exception(result: {message, code}, command: command, args: args) do
    %JQ.SystemCmdException{message: msg(result: {message, code}, command: command, args: args)}
  end

  defp msg(result: {message, code}, command: command, args: args) do
    "#{inspect(message)}"
  end
end

defmodule JQ.NoResultException do
  defexception message: "JQ query yielded no result"
end

defmodule JQ.MaxByteSizeExceededException do
  defexception [:message]

  @impl true
  def exception(size: size, max_byte_size: max_byte_size) do
    %JQ.MaxByteSizeExceededException{
      message:
        "input of #{inspect(size)} byte(s) exceeds the maximum allowed byte size of #{
          inspect(max_byte_size)
        } byte(s)."
    }
  end
end

defmodule JQ.UnknownException do
  defexception [:message]

  @impl true
  def exception(any) do
    %JQ.UnknownException{
      message: "unknown exception occurred while executing System.cmd. #{inspect(any)}"
    }
  end
end
