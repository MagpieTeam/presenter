defmodule Magpie.DataAccess.Measurement do
  use Timex

  def get(id, from, to) do
    # get all dates
    dates = get_dates(from, to, [])
    
    Enum.reduce(dates, [], fn (date, acc) -> 
      {:ok, day} = DateFormat.format(date, "%Y-%m-%d", :strftime)
      get(id, day) ++ acc
    end)
  end
  
  def get(id, date) do
    {:ok, client} = :cqerl.new_client()
    {:ok, result} = :cqerl.run_query(client, "SELECT * FROM magpie.measurements WHERE sensor_id=#{id} AND date='#{date}' ORDER BY timestamp DESC;")

    #unpack([], {:ok, result})
    unpack([], result)
  end

  def get_dates(from, to, dates) do
    case Date.compare(from, to) do
      -1 ->
        next_day = Date.add(from, Time.to_timestamp(1, :days)) 
        get_dates(next_day, to, [from | dates])
      0 -> [from | dates]
      1 -> []
    end
  end

  defp unpack(acc, result) do
    case :cqerl.next(result) do
      {row, next_result} ->
        m = to_measurement(row)
        unpack([m | acc], next_result)
      :empty_dataset ->
        case :cqerl.fetch_more(result) do
          {:ok, next_result} -> unpack(acc, next_result)
          :no_more_result -> acc
        end
    end
  end

  # defp unpack(acc, :no_more_result) do
  #   acc
  # end

  # defp unpack(acc, {:ok, result}) do
  #   case :cqerl.all_rows(result) do
  #     [] -> unpack(acc, :cqerl.fetch_more(result))
  #     rows ->
  #       measurements = Enum.map(rows, &to_measurement/1)
  #       unpack(measurements ++ acc, :cqerl.fetch_more(result))
  #   end
  # end

  defp to_measurement(row) do
    [timestamp: row[:timestamp], value: row[:value]]
  end
end