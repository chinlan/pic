defmodule Pic.Pagination do
  import Ecto.Query
  alias Pic.Repo

  def query(query, assoc, page, per_page: per_page) when is_binary(page) do
    query(query, assoc, String.to_integer(page), per_page: per_page)
  end

  def query(query, assoc, page, per_page: per_page) do
    query
    |> limit(^(per_page + 1))
    |> offset(^(per_page * (page - 1)))
    |> Repo.all()
    |> Repo.preload(assoc)
  end

  def page(query, assoc, page, per_page: per_page) when is_binary(page) do
    page(query, assoc, String.to_integer(page), per_page: per_page)
  end

  def page(query, assoc, page, per_page: per_page) do
    results = query(query, assoc, page, per_page: per_page)
    has_next = length(results) > per_page
    has_prev = page > 1
    count = Repo.one(from(t in subquery(query), select: count("*")))
    %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      page: page,
      next_page: page + 1,
      first: (page - 1) * per_page + 1,
      last: Enum.min([page * per_page, count]),
      count: count,
      list: Enum.slice(results, 0, per_page)
    }
  end
end
