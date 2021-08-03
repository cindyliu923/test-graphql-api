module Mutations
  # Note that this is NOT supposed to be a production-ready authentication feature,
  # but just a small functioning prototype to show the basic concept. In a real app,
  # you should make sure to encrypt passwords properly before passing them around and
  # use a good token generation method, such as JWT.
  class SignInUser < BaseMutation
    null true

    argument :credentials, Types::Input::AuthProviderCredentialsInputType, required: false

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(credentials: nil)
      # basic validation
      return unless credentials

      user = User.find_by email: credentials[:email]

      # ensures we have the correct user
      return unless user
      return unless user.authenticate(credentials[:password])

      # use Ruby on Rails - ActiveSupport::MessageEncryptor, to build a token
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
      token = crypt.encrypt_and_sign("user-id:#{ user.id }")
      context[:session][:token] = token

      { user: user, token: token }
    end
  end
end
