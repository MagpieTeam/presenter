defmodule Magpie.DataAccess.Sensor do

  def get do
    {:ok, client} = :cqerl.new_client()
    {:ok, result} = :cqerl.run_query(client, "SELECT * FROM magpie.sensors;")

    sensors = :cqerl.all_rows(result)

    Enum.map(sensors, &to_sensor/1)
  end

  def get(id) do
    {:ok, client} = :cqerl.new_client()
    {:ok, result} = :cqerl.run_query(client, "SELECT * FROM magpie.sensors WHERE id = #{id};")

    [sensor | _] = :cqerl.all_rows(result)

    to_sensor(sensor)
  end

  defp to_sensor(s) do
    [id: :uuid.uuid_to_string(s[:id]), name: s[:name], unit_of_measure: s[:unit_of_measure]]
  end

end