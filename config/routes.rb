Rails.application.routes.draw do
  root to: "static_pages#index"
  resources :colortest, only: [:index]

  namespace :api, defaults: {format: :json} do
    resources :answer_choices, only: [:destroy] do # Destroy happens from poll edit.
      collection do
        patch :update_batch # Should be okay.  Need to find where this is happening.
        put :create_batch # Should be okay  Need to find where this is happening.
      end
    end

    # Called from #/answer/:poll_id (AnswerPoll)
    resources :responses, only: [:create]

    # Called from #/results/:poll_id (PollResult)
    resources :results, only: [:show]

    # Called from PollIndexPage when you update a title.
    resources :poll_groups, only: [:update]

    # show: ???
    # update: EditPoll
    # create: ??? Superceded by create_batch
    resources :polls, only: [:show, :create, :update] do
      collection do
        patch :group       # From poll index page
        patch :ungroup      # From poll index page
        patch :update_with_answer_choices
        delete :delete_batch
        delete :delete_responses
      end
      member do
        get :get_by_poll_identifier
      end

      # index: ???
      # create: Called from EditPoll?
      resources :answer_choices, only: [:index, :create]
    end

    resource :session, only: [:show, :create, :destroy]

    # This is ok / standard
    resources :users, only: [:create] do
      resources :polls, only: [:index] do
        collection do
          post :create_batch  # From multi-poll-form
        end
      end
    end

  end

end
