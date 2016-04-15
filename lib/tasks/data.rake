#
# Base Data, load with command: "rake db:base_data"
#

namespace :db do
  desc "Generate base data"
  task :base_data => :environment do

    puts "==  Data: generating base data ".ljust(79, "=")

    GroupAssignment.destroy_all
    SystemUpdate.destroy_all
    PackageUpdate.destroy_all
    PackageInstallation.destroy_all
    Package.destroy_all
    PackageGroup.destroy_all
    System.destroy_all
    SystemGroup.destroy_all
    User.destroy_all
    Role.destroy_all
    TaskExecution.destroy_all
    Task.destroy_all
    TaskState.destroy_all
    Job.destroy_all
    SystemUpdateState.destroy_all

    unassigned       = SystemGroup.create( { :name => "Unassigned-System", :permission_level => 1 } )
    default          = SystemGroup.create( { :name => "Default-System",    :permission_level => 1 } )
    db               = SystemGroup.create( { :name => "DB-System",         :permission_level => 6 } )
    ha               = SystemGroup.create( { :name => "HA-System",         :permission_level => 7 } )

    uncrit           = PackageGroup.create( { :name => "Uncritical",  :permission_level => 1 } )
    crit             = PackageGroup.create( { :name => "Critical",    :permission_level => 5 } )
    dbcrit           = PackageGroup.create( { :name => "DB Critical", :permission_level => 6 } )
    hacrit           = PackageGroup.create( { :name => "HA Critical", :permission_level => 7 } )

    update_available = SystemUpdateState.create( { :name => "Available" } ) 
    update_queued    = SystemUpdateState.create( { :name => "Queued for Installation" } ) 
    update_failed    = SystemUpdateState.create( { :name => "Failed" } ) 
    update_outdated  = SystemUpdateState.create( { :name => "Outdated" } ) 
    update_installed = SystemUpdateState.create( { :name => "Installed" } ) 

    task_pending     = TaskState.create( { :name => "Pending" } ) 
    task_queued      = TaskState.create( { :name => "Queued" } ) 
    task_failed      = TaskState.create( { :name => "Failed" } ) 
    task_done        = TaskState.create( { :name => "Done" } ) 

    admin            = Role.create( { :name => "Admin", :permission_level => 9 } )
    readonly         = Role.create( { :name => "Readonly", :permission_level => 0 } )

    pchriste         = User.create( { :name => "pchriste", :email => "some@address", :role => admin } )
    ubosshar         = User.create( { :name => "ubosshar", :email => "other@address",:role => admin } )

    puts "==  Data: generating sample data (done) ".ljust(79, "=") + "\n\n"
  end
end
