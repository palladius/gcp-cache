module ApplicationHelper

    def render_valid(model)
        model.valid? ?
            link_to("ð®ð¹ð",model) :
           'ð¤®' # "ðpukeððpukeð"
    end
end
