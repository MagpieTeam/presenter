defmodule MagpiePresenter.SensorController do
	use MagpiePresenter.Web, :controller

	def index(conn, _params) do

    conn
    |> assign(:sensors, Magpie.DataAccess.Sensor.get())
		|> render("sensors.html")
	end

  def batch(conn, params) do

    conn
    |> assign(:sensor, Magpie.DataAccess.Sensor.get(params["id"]))
    |> render("batchView.html")
  end

  def live(conn, _params) do
    render conn, "liveView.html"
  end

  def get_data(conn, params) do
    measurements = Magpie.DataAccess.Measurement.get(params["id"], params["from"], params["to"])

    data = Enum.reduce(measurements,"", fn(m, acc) ->
      acc <> "#{m[:timestamp]},#{m[:value]}\n"
    end)

    json(conn, data)
  end
end