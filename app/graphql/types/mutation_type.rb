module Types
  class MutationType < Types::BaseObject
    field :add_note, mutation: Mutations::AddNote
    field :create_user, mutation: Mutations::CreateUser
  end
end
