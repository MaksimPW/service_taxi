require Rails.root.join('lib', 'rails_admin_map.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Map)

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
   end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show do
      visible do
        bindings[:abstract_model].model.to_s == "Setting"
      end
    end

    #custom
    map
  end

  config.navigation_static_label = 'Maps'
  config.navigation_static_links = {
      'Order' => '/orders'
  }
end
