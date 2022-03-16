# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string(:email,              null: false, default: "")
      t.string(:encrypted_password, null: false, default: "")

      ## Auth0
      t.string(:provider)
      t.string(:uid)
      t.boolean(:bot, default: false)

      t.timestamps(null: false)
    end

    add_index(:users, :email, unique: true)

    create_table(:admin_users) do |t|
      ## Database authenticatable
      t.string(:email,              null: false, default: "")
      t.string(:encrypted_password, null: false, default: "")

      ## Auth0
      t.string(:provider)
      t.string(:uid)
      t.boolean(:bot, default: false)

      t.timestamps(null: false)
    end

    add_index(:admin_users, :email, unique: true)
  end
end
