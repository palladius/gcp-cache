module ApplicationHelper

    def render_valid(model)
        model.valid? ?
            link_to("🇮🇹👍",model) :
           '🤮' # "🍏puke🍏🍏puke🍏"
    end
end
