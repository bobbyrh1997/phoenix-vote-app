defmodule VoteAppWeb.QuestionControllerTest do
  use VoteAppWeb.ConnCase

  import VoteApp.VoteFixtures

  @create_attrs %{answer1: "some answer1", answer1_count: 42, answer2: "some answer2", answer2_count: 42, answer3: "some answer3", answer3_count: 42, answer4: "some answer4", answer4_count: 42, body: "some body", status: true}
  @update_attrs %{answer1: "some updated answer1", answer1_count: 43, answer2: "some updated answer2", answer2_count: 43, answer3: "some updated answer3", answer3_count: 43, answer4: "some updated answer4", answer4_count: 43, body: "some updated body", status: false}
  @invalid_attrs %{answer1: nil, answer1_count: nil, answer2: nil, answer2_count: nil, answer3: nil, answer3_count: nil, answer4: nil, answer4_count: nil, body: nil, status: nil}

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, ~p"/questions")
      assert html_response(conn, 200) =~ "Listing Questions"
    end
  end

  describe "new question" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/questions/new")
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "create question" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/questions", question: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/questions/#{id}"

      conn = get(conn, ~p"/questions/#{id}")
      assert html_response(conn, 200) =~ "Question #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/questions", question: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "edit question" do
    setup [:create_question]

    test "renders form for editing chosen question", %{conn: conn, question: question} do
      conn = get(conn, ~p"/questions/#{question}/edit")
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "update question" do
    setup [:create_question]

    test "redirects when data is valid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/questions/#{question}", question: @update_attrs)
      assert redirected_to(conn) == ~p"/questions/#{question}"

      conn = get(conn, ~p"/questions/#{question}")
      assert html_response(conn, 200) =~ "some updated answer1"
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/questions/#{question}", question: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, ~p"/questions/#{question}")
      assert redirected_to(conn) == ~p"/questions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/questions/#{question}")
      end
    end
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end
end
