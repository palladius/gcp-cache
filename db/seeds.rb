# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

SeedVersion = "1.1_221227"

fake_projects = [] 

(1..5).each do |ix|
    p = Project.create(
        project_id: "fake-riccardo-project-#{ix}",
        project_number: 12345678900 + ix,
        billing_account_id: '123456-7890AB-CDEF12',
        description: "Project # #{ix}.\nAdded by rake db:seed v#{SeedVersion}",
    )
    fake_projects << p
end

root_folder = Folder.create(
    name: 'my-root',
    folder_id: '1000',
    is_org: true, 
    #parent_id:string
    description: "This is my first root folder, also a dir. Added by rake db:seed v#{SeedVersion}",
)
root_folder2 = Folder.create(
    name: 'my-other-org',
    folder_id: '2000',
    is_org: true, 
    #parent_id:string
    description: "This is my second root folder, also a dir. Added by rake db:seed v#{SeedVersion}",
)
[ root_folder, root_folder2].each do |my_root| 
    (1..3).each do |i| 
        child_n = Folder.create(
            name: "my-l1-child#{i}",
            folder_id: "0#{i}00",
            is_org: false, 
            parent_id: my_root.id,
            description: "Child of #{my_root}. Added by rake db:seed v#{SeedVersion}",
        )
        fake_projects[i].setParent(child_n)
    end
end
