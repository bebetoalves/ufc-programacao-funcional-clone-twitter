defmodule Assovio.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :tweets, Assovio.Timeline.Tweet

    many_to_many :following, __MODULE__,
      join_through: "follows",
      join_keys: [follower_id: :id, followed_id: :id],
      on_replace: :delete

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    # Mensagem em português
    |> validate_required([:name, :email, :password], message: "Este campo não pode ficar em branco.")
    |> validate_length(:password, min: 6, message: "Este campo deve ter pelo menos %{count} caracteres.")
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Este e-mail não é válido.")
    |> unique_constraint(:email, message: "Este e-mail já está em uso.")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
