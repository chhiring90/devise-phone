require Root.join('lib/devise/strategies/custom_authentcation')

module Devise
  module Models
    module CustomAuthentication
      extend ActiveSupport::Concern

      included do
        attr_accessor :custom_user_group
      end

      class_methods do
        # defining a class method that can find or create a Resource record and returns it back
        # to our Authentication Strategy
        #
        # If a user needs to sign up first,
        #   with Registerable, merely look up the record in your database
        #   instead of creating a new one

        def find_or_create_with_authentication_profile(profile)
          resource = where(username: profile.user_id).find_or_create({ email: profile.e_mail_adress,
                                                                       first_name: profile.first_name, last_name: profile.last_name })
          resource.custom_user_group = profile.custom_user_group
          resource
        end

        ####################################
        # Overriden methods from Devise::Models::Authenticatable
        ####################################

        # This method takes as many arguments as there are elements in `serialize_into_session`
        #
        # It recreates a resource from session data
        #

        def serialize_from_session(_options = {})
          # Loopup the records with the primary key
          resource = find(id)

          # Assign any additional attributes
          resource.custom_user_group = custom_user_group

          # Return the Resource
          resource
        end

        # Searilize any data you want into the session. The Resource Primary Key or other Unique Identifier
        # is recommended
        # 
        # The items placed into this array should be Serializable, e.g. numbers, strings, and Hashes
        # Do not place entire Ruby objects or Arrays of objects into the session 

        def serialize_into_session(resource)
            [resource.id, resource.custom_user_group]
        end
      end
    end
  end
end
