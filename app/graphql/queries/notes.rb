module Queries
  class Notes < Queries::BaseQuery

    type Types::NoteType.connection_type, null: false

    def resolve
      ::Note.order(created_at: :desc)
    end
  end
end
