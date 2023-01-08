module FoldersHelper

    def render_folder(folder)
        (render_valid(folder) + link_to( folder, folder)).html_safe
    end

end
