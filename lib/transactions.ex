defmodule Transactions do
  # https://github.com/plataformatec/nimble_csv
  alias NimbleCSV.RFC4180, as: CSV

  def list_transactions do
    # Returns the contents of the file, or raises an error if the content is not there.
    # if it is there, just give me the contents.
    File.read!("lib/transactions-jan.csv")
    |> parse
    |> filter
    |> normalize
    |> sort
    |> print
  end

  defp parse(string) do
    string
    |> String.replace("\r", "")
    |> CSV.parse_string
  end

# This function is going through the rows (Enum) and then an anonymouse function is use Enum.drop, to drop the first row. Which is the account number
  defp filter(rows) do
    #Enum.map(rows, fn(row) -> Enum.drop(row, 1) end)
    Enum.map(rows, &Enum.drop(&1, 1)) # this is the simplified version of the above function.
  end

# Mapping through each of the rows, looking at the third element, and parse from string to number
  defp normalize(rows) do
    Enum.map(rows, &parse_amount(&1))
  end

# We can use pattern matching to assign a variable to each of the values straight from the function arguments.
# So in this function instead of just saying rows, we're saying accept a list, and there is going to be a date, description and amount
  defp parse_amount([date, description, amount]) do
    [date, description, parse_to_float(amount)]
  end

# we are changing from a string to a float, so we can then sort it
  defp parse_to_float(string) do
    string
    |> String.to_float
    |> abs # abs is giving an absolute value
  end


# It feeds the element 2 elements at a time (prev, curr), use logic to compare it that returns a boolean, then use the boolen to sort

  defp sort(rows) do
    Enum.sort(rows, &sort_asc_by_amount(&1, &2))
  end

# Using pattern matching, we capture the prev, next values, which will then return a boolean. Which .sort will use to sort in asc order

  defp sort_asc_by_amount([_, _, prev], [_, _, next]) do
    prev < next
  end

  defp print(rows) do
    IO.puts "\nTransactions:"
    Enum.each(rows, &print_to_console(&1))
  end

  defp print_to_console([date, description, amount]) do
    IO.puts "#{date} #{description} \t$#{:erlang.float_to_binary(amount, decimals: 2)}"
  end

end
