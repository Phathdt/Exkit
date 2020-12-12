defmodule Exkit.Paginator do
  @moduledoc """
  Exkit.Paginator
  """
  import Ecto.Query

  def paginate(query, params, repo, opts \\ []) do
    page_number = (Map.get(params, "page") || Map.get(params, :page) || 1) |> to_int
    page_size = (Map.get(params, "size") || Map.get(params, :size) || 20) |> to_int
    entries = entries(query, page_number, page_size, repo)
    total? = Map.get(params, "count_total") || Keyword.get(opts, :count_total, false)

    cnt =
      if total? do
        count_entry(query, repo)
      else
        0
      end

    paginator = %{
      page: page_number,
      size: page_size,
      total: cnt,
      total_pages: ceil(cnt / page_size),
      total_entries: cnt,
      has_next: length(entries) >= page_size,
      has_prev: page_number > 1
    }

    {entries, paginator}
  end

  defp entries(query, page_number, page_size, repo) do
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> repo.all()
  end

  defp count_entry(query, repo) do
    query
    |> exclude(:order_by)
    |> exclude(:preload)
    |> exclude(:select)
    |> select(
      [e],
      fragment(
        "count(distinct ?)",
        e.id
      )
    )
    |> repo.one()
  end

  defp to_int(s) do
    case Ecto.Type.cast(:integer, s) do
      {:ok, value} -> value
      :error -> :error
    end
  end
end
