defmodule VoteAppWeb.LoginConfirmationInstructionsLiveTest do
  use VoteAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import VoteApp.AuthFixtures

  alias VoteApp.Auth
  alias VoteApp.Repo

  setup do
    %{login: login_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/logins/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, login: login} do
      {:ok, lv, _html} = live(conn, ~p"/logins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", login: %{email: login.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Auth.LoginToken, login_id: login.id).context == "confirm"
    end

    test "does not send confirmation token if login is confirmed", %{conn: conn, login: login} do
      Repo.update!(Auth.Login.confirm_changeset(login))

      {:ok, lv, _html} = live(conn, ~p"/logins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", login: %{email: login.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Auth.LoginToken, login_id: login.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/logins/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", login: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Auth.LoginToken) == []
    end
  end
end
