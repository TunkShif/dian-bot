defmodule Dian.Storage.Adapter do
  @callback get_url(String.t()) :: String.t()
  @callback exists?(String.t()) :: boolean()
  @callback upload(String.t(), any(), content_type: String.t()) ::
              {:ok, String.t()} | {:error, any()}
end
