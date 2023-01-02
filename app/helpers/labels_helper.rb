module LabelsHelper

    def render_label(label)
        #label_html = label.to_s + ""
        first_part = link_to(label, label) 
        second_part = link_to(" @ #{label.labellable.to_s(false)}",label.labellable) rescue 'ERR'

        return (render_valid(label) + first_part + second_part).html_safe
    end
end
