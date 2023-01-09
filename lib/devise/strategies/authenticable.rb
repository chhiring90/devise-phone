require 'devise/strategies/authenticable'

module Devise
  module Strategies
    class CustomAuthenticable < Authenticable

      # Store response from remote authentication service, such as an SSO Token or API Key
      attr_accessor :sso_token

      # All Strategies must define this method.
      def authenticate!
        raise(:unable_to_authenticate) unless password.present? && has_valid_credentials?

        resource = mapping.to.find_or_create_with_authentication_profile(get_authentication_profile)
        success!(resource)
      end

      ## returns true or false if the given user is found on MyPassport
      def has_valid_credentials?
        # Implement logic that returns a True or False if the user's credentials are correct.
        # We'll generate a resource later, but first we need to know we're dealing with a legit request.
      end

      def get_authentication_profile
        # returns some data about the user that was in the response from the Remote Authentication Service.
        # Most SSO Systems will return back a user's UniqueID, Email Address, and other attributes that can be used
        # to further refine access to resources in your Rails app.
      end
    end
  end
end

Warden::Strategies.add(:custom_authenticable, Devise::Strategies::CustomAuthenticable)