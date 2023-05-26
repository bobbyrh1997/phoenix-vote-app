defmodule VoteAppWeb.QuestionController do
  use VoteAppWeb, :controller

  alias VoteApp.Vote
  alias VoteApp.Vote.Question

  def index(conn, _params) do
    questions = Vote.list_questions()
    render(conn, :index, questions: questions)
  end

  def new(conn, _params) do
    changeset = Vote.change_question(%Question{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"question" => question_params}) do
    case Vote.create_question(question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: ~p"/questions/#{question}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Vote.get_question!(id)
    render(conn, :show, question: question)
  end

  def edit(conn, %{"id" => id}) do
    question = Vote.get_question!(id)
    changeset = Vote.change_question(question)
    render(conn, :edit, question: question, changeset: changeset)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Vote.get_question!(id)

    case Vote.update_question(question, question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: ~p"/questions/#{question}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, question: question, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Vote.get_question!(id)
    {:ok, _question} = Vote.delete_question(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: ~p"/questions")
  end
end
