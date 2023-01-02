module ApplicationHelper

    def render_valid(model)
        model.valid? ? 
            link_to("👍",model) : 
            "❌" #⁉️X🇮🇹 
    end
end
