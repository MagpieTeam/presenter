defmodule MagpiePresenter.SensorController do
	use MagpiePresenter.Web, :controller
  use Timex

  def batch(conn, params) do
    conn
    |> assign(:sensor, Magpie.DataAccess.Sensor.get(params["id"]))
    |> render("batchView.html")
  end

  def live(conn, params) do
    
    conn
    |> assign(:sensor, Magpie.DataAccess.Sensor.get(params["id"]))
    |> render("liveView.html")
  end

  def get_data(conn, params) do
    {:ok, from} = DateFormat.parse(params["from"], "{YYYY}-{0M}-{0D}")
    {:ok, to} = DateFormat.parse(params["to"], "{YYYY}-{0M}-{0D}")
    measurements = Magpie.DataAccess.Measurement.get(params["id"], from, to)

    data = Enum.reduce(measurements,"", fn(m, acc) ->
      acc <> "#{m[:timestamp]},#{m[:value]}\n"
    end)

    json(conn, data)
  end
end