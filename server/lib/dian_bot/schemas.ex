defmodule DianBot.Schemas do
  use TypedStruct

  defmodule User do
    typedstruct do
      field :qid, String.t(), enforce: true
      field :nickname, String.t(), enforce: true
    end
  end

  defmodule Group do
    typedstruct do
      field :gid, String.t(), enforce: true
      field :name, String.t(), enforce: true
      field :description, String.t()
    end
  end

  defmodule Message do
    typedstruct do
      field :mid, String.t()
      field :qid, String.t(), enforce: true
      field :gid, String.t(), enforce: true
      field :raw_text, String.t(), enforce: true
      field :sent_at, DateTime.t(), enforce: true
    end
  end

  defmodule Event do
    typedstruct do
      field :mid, String.t(), enforce: true
      field :qid, String.t(), enforce: true
      field :gid, String.t(), enforce: true
      field :marked_at, DateTime.t(), enforce: true
    end
  end
end
