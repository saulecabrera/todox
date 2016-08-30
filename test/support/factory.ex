defmodule Todox.Factory do

  @moduledoc"""
  Factory module, used to generate data for tests
  """

  use ExMachina.Ecto, repo: Todox.Repo
  alias Todox.{User, Todo}

  # User
  
  def user_factory do
    %User{} 
  end

  def todo_factory do
    %Todo{
      title: "Test Todo",
      description: "Description for a test Todo"
    }
  end
end
