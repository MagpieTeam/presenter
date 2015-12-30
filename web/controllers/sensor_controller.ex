defmodule MagpiePresenter.SensorController do
	use MagpiePresenter.Web, :controller
  use Timex

  def batch(conn, params) do
    {:ok, sensor} = Magpie.DataAccess.Sensor.get(params["id"], params["logger_id"])
    conn
    |> assign(:sensor, sensor)
    |> render("batchView.html")
  end

  def live(conn, params) do
    {:ok, sensor} = Magpie.DataAccess.Sensor.get(params["id"], params["logger_id"])
    
    conn
    |> assign(:sensor, sensor)
    |> render("liveView.html")
  end

  def get_data(conn, params) do
    {:ok, from} = DateFormat.parse(params["from"], "{0M}/{0D}/{YYYY} {h24}:{m}:{s}")
    {:ok, to} = DateFormat.parse(params["to"], "{0M}/{0D}/{YYYY} {h24}:{m}:{s}")

    # TODO: if no date given, it returns {:error, "message"}
    measurements = Magpie.DataAccess.Measurement.get(params["id"], from, to)
    data = Enum.reduce(measurements,"", fn(m, acc) ->
      acc <> "#{m[:timestamp]},#{m[:value]}\n"
    end)

    json(conn, data)
  end
end