defmodule MagpiePresenter.SensorController do
	use MagpiePresenter.Web, :controller

	def index(conn, params) do

    conn
    #|> assign(:sensors, Magpie.DataAccess.Sensor.get("logger_id"))
		|> assign(:logger, [1,2])
    |> assign(:sensors, [[1,1,1]])
    |> render("sensors.html")
	end

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
    measurements = Magpie.DataAccess.Measurement.get(params["id"], params["from"], params["to"])

    data = Enum.reduce(measurements,"", fn(m, acc) ->
      acc <> "#{m[:timestamp]},#{m[:value]}\n"
    end)

    json(conn, data)
  end
end