defmodule ReportsHours.HoursPerYear do
  alias ReportsHours.Parse

  def build(file, list_name) do
    list_years =
      file
      |> generate_list_years()

    list_name =
      list_name
      |> report_acc(list_years)

    file
    |> Parse.parse_file()
    |> Enum.reduce(list_name, fn line, report -> sum_values(line, report) end)
  end

  defp report_acc(list, list_years) do
    list
    |> Enum.into(%{}, fn x -> {x, Enum.into(list_years, %{}, &{&1, 0})} end)
  end

  defp sum_values([name, hours, _day, _month, year], %{} = report) do
    list = Map.put(report[name], year, report[name][year] + hours)
    %{report | name => list}
  end

  defp generate_list_years(file) do
    file
    |> Parse.parse_file()
    |> Enum.map(fn [_name, _hours, _day, _month, year] -> year end)
    |> Enum.uniq()
  end
end
