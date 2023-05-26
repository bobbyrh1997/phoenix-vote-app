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
end
