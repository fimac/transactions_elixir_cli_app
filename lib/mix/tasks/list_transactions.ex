defmodule Mix.Tasks.ListTransactions do

  use Mix.Task

  @shortdoc "List transactions from CSV file"
  def run(_) do
    Transactions.list_transactions
  end

end
