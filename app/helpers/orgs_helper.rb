module OrgsHelper


    # HTML view of the tree, probably better with UL and LI.
    def render_org_recursively_html(folder, depth=0, opts={})
        # options
        opts_also_add_projects = opts.fetch :also_add_projects, false
        opts_debug = opts.fetch :debug, true
        
        raise "This is not a Folder! Instead its a: '#{folder.class}'" unless  folder.is_a?(Folder)

        # 1. First, the father
        indentation = " #{FOLDER_ICON}" * depth
        debug_info = opts_debug ? "[L🌊=#{depth}]" : ''
        ret = indentation + debug_info + link_to( "🗂️ OrgView(#{folder.name})", "/orgs/#{folder.id}" ) + "<br/>" # rescue :Err
        # 2. Then, the N children
        folder.children.each do |child_folder|
            ret += render_org_recursively_html(child_folder, depth+1, opts).html_safe
        end
        ret.html_safe
    end


    def render_org_recursively_txt(folder, depth=0, opts={})
        raise "This is not a Folder! Instead its a: '#{folder.class}'" unless  folder.is_a?(Folder)
        folder.carlessian_tree_view(depth, opts)

        # # options
        # opts_also_add_projects = opts.fetch :also_add_projects, false
        # #main
        # # 1. First, the father
        # indentation = "-H-" * depth
        # ret = "#{indentation}[L🌊=#{depth}]" + folder.to_s + "\n" # .name})", "/orgs/#{folder.id}" ) + "<br/>" # rescue :Err
        # # 2. Then, the N children
        # folder.children.each do |child_folder|
        #     ret +=  render_org_recursively_txt(child_folder, depth+1, opts).html_safe
        # end
        # ret.html_safe
    end   


    def render_org(folder)
        link_to "🗂️ Org(#{folder.name})", "/orgs/#{folder.id}" 
    end
    def render_org_as_tr(folder) 
        return "<tr>
        <th>Valid
        <th>#Id
        <th>FolderId
        <th>Domain
        <th>directoryCustomerId
        <th>Org Info 
        </tr>".html_safe if folder.nil?

        "<tr>
        <td>#{render_valid folder}
        <td>#{link_to folder.id, "/folders/#{folder.id}"}
        <td><b>#{folder.folder_id}</b>
            <td>#{folder.domain}
            <td>#{folder.directory_customer_id}
            <td>#{ render_org folder } 
        </tr>".html_safe
    end

end


#children