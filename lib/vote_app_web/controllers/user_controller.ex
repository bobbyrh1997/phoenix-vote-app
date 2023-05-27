defmodule VoteAppWeb.UserController do
  use VoteAppWeb, :controller

  alias VoteApp.Accounts
  alias VoteApp.Accounts.User


  def index(conn,_params) do
    users = Accounts.list_users()
    render(conn,:index,users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(String.to_integer(id));
    render(conn, :show, users: user)
  end

  def new(conn,_params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new,changeset: changeset)
  end

  def create(conn,%{"user" => user_params}) do
    {:ok, user} = Accounts.create_user(user_params)

    conn
    |>put_flash(:info, "#{user.name} created")
    |>redirect(to: ~p"/users")
  end
end
