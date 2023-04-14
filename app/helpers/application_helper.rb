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

    def render_db_with_emoji()
        config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env ).first
        adapter = config.adapter
        db = config.database
        emoji = case adapter
        when 'postgresql'
            '🐘pg🛢'
        when 'mysql'
            '🐬my🛢'
        when 'sqlite', 'sqlite3'
            '🪶lt🛢'
        else 
            '🛢?!?🛢'
        end
        "#{emoji} <b>#{db}</b>".html_safe
    end
end
