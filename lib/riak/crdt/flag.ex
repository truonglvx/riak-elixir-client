defmodule Riak.CRDT.Flag do
  @moduledoc """
  Encapsulates a boolean datatype inside a CRDT.Map
  """
  require Record

  @doc """
  Creates a new flag container
  """
  def new, do: :riakc_flag.new
  def new(context) when is_binary(context), do: :riakc_flag.new(context)
  def new(value) when is_boolean(value), do: :riakc_flag.new(value, :undefined)
  def new(value, context) when is_boolean(value) and is_binary(context), do: :riakc_flag.new(value, context)

  @doc """
  Extracts current value of `flag`
  """
  def value(flag) when Record.is_record(flag, :flag) do
    :riakc_flag.value(flag)
  end
  def value(nil), do: {:error, :nil_object}

  @doc """
  Turns the value to true
  """
  def enable(flag) when Record.is_record(flag, :flag) do
    :riakc_flag.enable(flag)
  end
  def enable(nil), do: {:error, :nil_object}

  @doc """
  Turns the value to false
  """
  def disable(flag) when Record.is_record(flag, :flag) do
    # This is not ideal, create a :riakc_flag::flag() record with a disable op
    case flag do
      {:flag, value, _, :undefined} ->
        {:flag, value, :disable, :undefined};
      _ -> :riakc_flag.disable(flag)
    end
  end
  def disable(nil), do: {:error, :nil_object}
end
