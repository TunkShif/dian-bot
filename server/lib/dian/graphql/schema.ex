defmodule Dian.GraphQL.Schema do
  use Absinthe.Schema

  query do
    field :text, :string do
      resolve fn _, _, _ -> {:ok, "Hello, World"} end
    end
  end
end
