module ApplicationHelper

    def render_valid(model)
        model.valid? ? 
            link_to("🇮🇹👍",model) : 
            "🍏puke🍏" 
    end
end
