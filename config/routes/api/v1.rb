# See `config/routes.rb` for details.
collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment
extending = {only: []}

shallow do
  namespace :v1 do
    # user specific resources.
    resources :users, extending do
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth providers above this line.
      end

      # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
    end

    # team-level resources.
    resources :teams, extending do
      # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

      # add your resources here.

      resources :invitations, extending do
        # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      resources :memberships, extending do
        # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      namespace :integrations do
        # 🚅 super scaffolding will insert new integration installations above this line.
      end

      resources :demographics, concerns: [:sortable]
      resources :departments, concerns: [:sortable]
      resources :locations, concerns: [:sortable]
      resources :items do
        scope module: 'items' do
          resources :options, only: collection_actions, concerns: [:sortable]
        end
      end
      resources :organizations
      resources :retreats do
        scope module: 'retreats' do
          resources :comments, only: collection_actions
        end
      end
      resources :reservations
      namespace :items do
        resources :tags
        resources :options, except: collection_actions, concerns: [:sortable]
        resources :areas, concerns: [:sortable]
      end

      resources :flights, concerns: [:sortable]
      namespace :flights do
        resources :timeframes, concerns: [:sortable]
        resources :checks
      end

      namespace :organizations do
        resources :contacts
      end

      namespace :retreats do
        resources :comments, except: collection_actions
        resources :requests
      end

      resources :notifications
      namespace :notifications do
        resources :flags
        resources :requests
      end

      resources :seasons
      resources :questions, concerns: [:sortable]
      resources :websiteimages
      resources :games
      resources :medforms
    end
  end
end
