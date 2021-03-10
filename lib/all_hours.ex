defmodule ReportsHours.Allhours do
  alias ReportsHours.Parse

  def build(file, list_name) do
    list_name =
      list_name
      |> report_acc()

    file
    |> Parse.parse_file()
    |> Enum.reduce(list_name, fn line, report -> sum_values(line, report) end)
  end

  defp sum_values([name, hours, _day, _month, _year], report) do
    Map.put(report, name, report[name] + hours)
  end

  defp report_acc(list) do
    list
    |> Enum.into(%{}, &{&1, 0})
  end
end
