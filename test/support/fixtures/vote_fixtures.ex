defmodule VoteApp.VoteFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VoteApp.Vote` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        answer1: "some answer1",
        answer1_count: 42,
        answer2: "some answer2",
        answer2_count: 42,
        answer3: "some answer3",
        answer3_count: 42,
        answer4: "some answer4",
        answer4_count: 42,
        body: "some body",
        status: true
      })
      |> VoteApp.Vote.create_question()

    question
  end
end
