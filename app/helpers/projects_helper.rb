module ProjectsHelper
    def render_project(project)
        link_to "#{PROJECT_ICON} #{project.to_s}", project
        # add parent if ..
    end

end
