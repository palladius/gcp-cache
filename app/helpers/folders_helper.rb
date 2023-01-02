module FoldersHelper

    def render_folder(folder)
        link_to folder, folder
        # add parent if ..
    end

end
