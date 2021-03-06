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
    router_ip = MagpiePresenter.Endpoint.config(:router_ip)
    
    conn
    |> assign(:sensor, sensor)
    |> assign(:router_ip, router_ip)
    |> render("liveView.html")
  end

  def get_data(conn, params) do
    {:ok, from} = DateFormat.parse(params["from"], "{0M}/{0D}/{YYYY} {h24}:{m}:{s}")
    {:ok, to} = DateFormat.parse(params["to"], "{0M}/{0D}/{YYYY} {h24}:{m}:{s}")

    resolution = 
      case Date.diff(from, to, :secs) do
        x when x < 10000 ->
          :seconds
        x when x < 600000 ->    
          :minutes
        _ ->
          :hours
      end

    # TODO: if no date given, it returns {:error, "message"}
    measurements = Magpie.DataAccess.Measurement.get(params["id"], from, to, resolution)

    case resolution do
      :seconds ->
        data = Enum.reduce(measurements,"", fn(m, acc) ->
          acc <> "#{m[:timestamp]},#{m[:value]}\n"
        end)
        json(conn, data)
      _ ->
        data = Enum.reduce(measurements,"", fn(m, acc) ->
          acc <> "#{m[:timestamp]},#{m[:avg]}\n"
        end)
        json(conn, data)
    end
  end
end