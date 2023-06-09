defmodule VoteAppWeb.LoginConfirmationLiveTest do
  use VoteAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import VoteApp.AuthFixtures

  alias VoteApp.Auth
  alias VoteApp.Repo

  setup do
    %{login: login_fixture()}
  end

  describe "Confirm login" do
    test "renders confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/logins/confirm/some-token")
      assert html =~ "Confirm Account"
    end

    test "confirms the given token once", %{conn: conn, login: login} do
      token =
        extract_login_token(fn url ->
          Auth.deliver_login_confirmation_instructions(login, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/logins/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Login confirmed successfully"

      assert Auth.get_login!(login.id).confirmed_at
      refute get_session(conn, :login_token)
      assert Repo.all(Auth.LoginToken) == []

      # when not logged in
      {:ok, lv, _html} = live(conn, ~p"/logins/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Login confirmation link is invalid or it has expired"

      # when logged in
      {:ok, lv, _html} =
        build_conn()
        |> log_in_login(login)
        |> live(~p"/logins/confirm/#{token}")

      result =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert {:ok, conn} = result
      refute Phoenix.Flash.get(conn.assigns.flash, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, login: login} do
      {:ok, lv, _html} = live(conn, ~p"/logins/confirm/invalid-token")

      {:ok, conn} =
        lv
        |> form("#confirmation_form")
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "Login confirmation link is invalid or it has expired"

      refute Auth.get_login!(login.id).confirmed_at
    end
  end
end
