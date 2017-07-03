defmodule Sokrat.Decorators.Revision do
  def list(items) do
    Enum.map(items, &single/1) |> Enum.join("\n")
  end

  def single(item) do
    "*#{item.server}:* _#{item.branch}_ #{item.deployed_at} UTC"
  end
end
