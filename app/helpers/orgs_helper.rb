module OrgsHelper


    # HTML view of the tree, probably better with UL and LI.
    def render_org_recursively_html(folder, depth=0, opts={})
        # options
        opts_also_add_projects = opts.fetch :also_add_projects, false
        opts_debug = opts.fetch :debug, true
        #main
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

        # options
        opts_also_add_projects = opts.fetch :also_add_projects, false
        #main
        # 1. First, the father
        indentation = "--" * depth
        ret = "#{indentation}[L🌊=#{depth}]" + folder.to_s + "\n" # .name})", "/orgs/#{folder.id}" ) + "<br/>" # rescue :Err
        # 2. Then, the N children
        folder.children.each do |child_folder|
            ret +=  render_org_recursively_txt(child_folder, depth+1, opts).html_safe
        end
        ret.html_safe
    end   

end


#children