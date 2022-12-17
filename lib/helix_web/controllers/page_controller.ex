defmodule HelixWeb.PageController do
  use HelixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
