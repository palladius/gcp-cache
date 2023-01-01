module FoldersHelper

    def render_folder(folder)
        link_to folder, folder
        # add parent if ..
    end

    def render_org(folder)
        link_to "🗂️ Org(#{folder.name})", "/orgs/#{folder.id}" 
    end
    def render_org_as_tr(folder) 
        return "<tr>
        <th>#Id
        <th>FolderId
        <th>Domain
        <th>directoryCustomerId
        <th>Org Info 
        </tr>".html_safe if folder.nil?

        "<tr>
            <td>#{link_to folder.id, "/folders/#{folder.id}"}
            <td><b>#{folder.folder_id}</b>
            <td>#{folder.domain}
            <td>#{folder.directory_customer_id}
            <td>#{ render_org folder } 
        </tr>".html_safe
    end
end
