defmodule ReportsHours do
  alias ReportsHours.Parse

  alias ReportsHours.Allhours

  alias ReportsHours.HoursPerMonth

  alias ReportsHours.HoursPerYear

  def build(filename) do
    list_name =
      filename
      |> Parse.parse_file()
      |> generate_list_name()

    all_hours =
      filename
      |> Allhours.build(list_name)

    hours_per_month =
      filename
      |> HoursPerMonth.build(list_name)

    hours_per_year =
      filename
      |> HoursPerYear.build(list_name)

    %{
      all_hours: all_hours,
      hours_per_month: hours_per_month,
      hours_per_year: hours_per_year
    }
  end

  defp generate_list_name(list) do
    list
    |> Enum.map(fn [head | _tail] -> head end)
    |> Enum.uniq()
  end
end
