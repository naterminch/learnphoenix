# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :auction, ecto_repos: [Auction.Repo]

config :auction, Auction.Repo,
  database: "auction_prod",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
