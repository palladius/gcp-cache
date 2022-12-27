module FoldersHelper

    def render_folder(folder)
        link_to folder, folder
        # add parent if ..
    end

    def render_org(folder) 
        link_to "🗂️ OrgView(#{folder.name})", "/orgs/#{folder.id}" 

    end
end
