defmodule ReportsHours.HoursPerMonth do
  @month_index %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "semtembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  alias ReportsHours.Parse

  def build(file, list_name) do
    list_months =
      file
      |> generate_list_months()

    list_name =
      list_name
      |> report_acc(list_months)

    file
    |> Parse.parse_file()
    |> Enum.reduce(list_name, fn line, report -> sum_values(line, report) end)
    |> insert_months_name()
  end

  defp report_acc(list, list_months) do
    list
    |> Enum.into(%{}, fn x -> {x, Enum.into(list_months, %{}, &{&1, 0})} end)
  end

  defp sum_values([name, hours, _day, month, _year], %{} = report) do
    list_of_months = Map.put(report[name], month, report[name][month] + hours)
    %{report | name => list_of_months}
  end

  defp generate_list_months(file) do
    file
    |> Parse.parse_file()
    |> Enum.map(fn [_name, _hours, _day, month, _year] -> month end)
    |> Enum.uniq()
  end

  defp insert_months_name(list) do
    list
    |> Enum.reduce(%{}, fn {name, list_of_months}, completed_list ->
      list_with_names =
        list_of_months
        |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, @month_index[k], v) end)

      Map.put(completed_list, name, list_with_names)
    end)

    # |> Enum.map(fn {name, list} ->
    #  %{name => Enum.map(list, fn {month, value} -> %{@month_index[month] => value} end)}
    # end)
  end
end
