defmodule Exkit.MapHelper do
  def clean_nil_values(m) when is_list(m) do
    m |> Enum.map(&clean_nil_values/1)
  end

  def clean_nil_values(m) when is_map(m) do
    Enum.reduce(m, %{}, fn
      {key, value}, acc when is_list(value) -> Map.put(acc, key, clean_nil_values(value))
      {_key, nil}, acc -> acc
      {key, value}, acc -> Map.put(acc, key, value)
    end)
  end

  def clean_nil_values(m), do: m

  def clean_empty_values(m) do
    Enum.reduce(m, %{}, fn
      {_key, ""}, acc -> acc
      {key, value}, acc -> Map.put(acc, key, value)
    end)
  end
end
