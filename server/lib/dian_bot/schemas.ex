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
      field :sender, User.t(), enforce: true
      field :group, Group.t(), enforce: true
      field :raw_text, String.t(), enforce: true
      field :content, DianBot.Coucou.result()
      field :sent_at, DateTime.t(), enforce: true
    end

    @spec parse_content(Message.t()) :: t()
    def parse_content(%Message{} = message) do
      case message.content do
        nil ->
          content = DianBot.Coucou.parse_message(message.raw_text)
          %Message{message | content: content}

        message ->
          message
      end
    end
  end

  defmodule Event do
    typedstruct do
      field :id, String.t(), enforce: true
      field :message, Message.t(), enforce: true
      field :owner, User.t(), enforce: true
      field :group, Group.t(), enforce: true
      field :marked_at, DateTime.t(), enforce: true
    end
  end
end
