module Mutations
  class AddNote < Mutations::BaseMutation
    argument :params, Types::Input::NoteInputType, required: true

    field :note, Types::NoteType, null: false

    def resolve(params:)
      note_params = set_params(params)

      begin
        note = Note.create!(note_params)

        { note: note }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
          " #{e.record.errors.full_messages.join(', ')}")
      end
    end

    def set_params(params)
      hash_params = Hash(params)
      hash_params[:user] = context[:current_user] if context[:current_user].present?
      hash_params
    end
  end
end
