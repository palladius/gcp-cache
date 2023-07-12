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
#        link_to "🗂️ Org(#{folder.name})", "/orgs/#{folder.id}"
        link_to "🗂️ #{folder.name}", "/orgs/#{folder.id}"
    end


    # bootstrap https://getbootstrap.com/docs/4.0/content/tables/
    def render_org_as_tr(folder)
        return '<tr>
        <th scope="col">Valid / Active
          <th scope="col">#Id
          <th scope="col">FolderId //
          <th scope="col">Domain // Org Info
          <th scope="col">Children
          <th scope="col">Desc
        </tr>'.html_safe if folder.nil?

        "<tr>
        <!-- < t h scope='row' >2 < / t h > -->
        <td>#{render_valid folder} / #{render_active folder}
        <td>#{link_to folder.id, "/folders/#{folder.id}"}
            #{ link_to "✏️", edit_folder_path(folder) }

        <td>#{folder.folder_id} <br/>
            <b>#{folder.directory_customer_id}</b>

        <td><b>#{folder.domain}</b> <br/>
            #{ render_org folder }

        <td>#{ render_children_count_for_folder folder }
        <td>#{ folder.description }

        </tr>".html_safe
    end

    def render_children_count_for_folder(folder)
        ret = ''
        folder_count = folder.sub_folders.count
        project_count = folder.sub_projects.count
        ret +=  "#{folder_count}&nbsp;📂" if folder_count > 0
        ret +=  "#{project_count }&nbsp;🍕" if project_count > 0
        ret
    end

end


#children
