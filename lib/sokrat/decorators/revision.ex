defmodule Sokrat.Decorators.Revision do
  @moduledoc false

  def list(items) do
    items
    |> Enum.map(&single/1)
    |> Enum.join("\n")
  end

  def single(item) do
    "*#{item.server}:* _#{item.branch}_ #{item.deployed_at} UTC"
  end
end
