module ProjectsHelper
    def render_project(project)
        (render_valid(project) + 
        link_to("#{PROJECT_ICON} #{project.to_s}", project)
        ).html_safe
        # add parent if ..
    end

end
