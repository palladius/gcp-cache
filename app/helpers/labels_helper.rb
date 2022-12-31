module LabelsHelper

    def render_label(label)
        link_to(label, label)
    end
end
