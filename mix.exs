defmodule AuctionUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      name: "auction_umbrella",
      apps_path: "./apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:ex_doc, "~>0.19", dev: true, runtime: false}
    ]
  end
end
