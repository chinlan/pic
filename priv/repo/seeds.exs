# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pic.Repo.insert!(%Pic.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Pic.Repo
alias Pic.PicWeb.User
Repo.insert! %User{
  email: "user@example.com",
  encrypted_password: "passw0rd"
}
