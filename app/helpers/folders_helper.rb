module FoldersHelper

    def render_folder(folder)
        (render_valid(folder) + link_to( folder, folder)).html_safe
    end

    def render_parent_folder_by_folder_id(folder_id)
      f = Folder.find_by_folder_id(folder_id) # rescue nil
      return link_to f,f if f.is_a? Folder
      '-'
    end

end
