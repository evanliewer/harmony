Rails.application.routes.draw do
  # See `config/routes/*.rb` to customize these configurations.
  draw "concerns"
  draw "devise"
  draw "sidekiq"
  draw "avo"

  # `collection_actions` is automatically super scaffolded to your routes file when creating certain objects.
  # This is helpful to have around when working with shallow routes and complicated model namespacing. We don't use this
  # by default, but sometimes Super Scaffolding will generate routes that use this for `only` and `except` options.
  collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment

  # This helps mark `resources` definitions below as not actually defining the routes for a given resource, but just
  # making it possible for developers to extend definitions that are already defined by the `bullet_train` Ruby gem.
  # TODO Would love to get this out of the application routes file.
  extending = {only: []}

  scope module: "public" do
    # To keep things organized, we put non-authenticated controllers in the `Public::` namespace.
    # The root `/` path is routed to `Public::HomeController#index` by default.
    get 'public_reservation' => 'home#public_reservation', as: 'public_reservation'
    post 'new_public_reservation' => 'home#new_public_reservation', as: 'new_public_reservation'
    patch 'new_public_reservation' => 'home#new_public_reservation', as: 'edit_public_reservation'
    get 'destroy_reservation' => 'home#destroy_reservation', as: 'destroy_reservation' 
    get '/game_show/:color' => 'home#game_show', as: 'game_show'
    get '/waiver/:retreat' => 'home#waiver', as: 'waiver'
    post 'waiver/create_public_waiver', to: 'home#create_public_waiver', as: 'create_public_waiver'
    get 'thank_you' => 'home#thank_you', as: 'thank_you'
    # Standalone routes for public medform actions
  #get 'medform/new', to: 'medform#new_public', as: :new_public_medform


  end

  namespace :webhooks do
    namespace :incoming do
      resources :jotform_webhooks
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth provider webhooks above this line.
      end
    end
  end

  namespace :api do
    draw "api/v1"
    # 🚅 super scaffolding will insert new api versions above this line.
  end

  namespace :account do
    shallow do
      # user-level onboarding tasks.
      namespace :onboarding do
        # routes for standard onboarding steps are configured in the `bullet_train` gem, but you can add more here.
      end

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

        put 'toggle_flightcheck', to: 'flights#toggle_flightcheck', as: :toggle_flightcheck
        get 'create_seasonal_reservations' => 'reservations#create_seasonal_reservations', as: 'create_seasonal_reservations'
        get 'remove_seasonal_reservations' => 'reservations#remove_seasonal_reservations', as: 'remove_seasonal_reservations'
        patch 'fullcalendar_update/', to: 'reservations#fullcalendar_update', as: :fullcalendar_update
        patch '/account/:team_id/fullcalendar_update', to: 'account/teams#update_fullcalendar_event', as: 'account_team_fullcalendar_update'
        get 'print_retreat' => 'retreats#print', as: 'print_retreat'
        get 'print_gold' => 'retreats#gold', as: 'print_gold'
        get '/lodging' => 'items#lodging', as: 'lodging'
        get 'schedule_json' => 'reservations#schedule_json', as: 'schedule_json'

        resources :demographics, concerns: [:sortable]
        resources :departments, concerns: [:sortable]
        resources :locations, concerns: [:sortable, :activity]
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
          member do
            get :department_view
            get :kitchen
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
        resources :diets, concerns: [:sortable]
      end
    end
  end
end
