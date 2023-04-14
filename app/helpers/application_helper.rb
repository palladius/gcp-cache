module ApplicationHelper

    def render_valid(model)
        return '🏎️'
        # very expensive
        # model.valid? ?
        #     link_to("🇮🇹👍",model) :
        #    '🤮' # "🍏puke🍏🍏puke🍏"
    end

    def render_active(model)
        # if model has no active -> error
        model.active ? '🚴' : '🩶'  rescue '?!?'
    end
end
