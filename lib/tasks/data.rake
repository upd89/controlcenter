#
# Base Data, load with command: "rake db:base_data"
#

namespace :db do
  desc "Generate base data"
  task :base_data => :environment do

    puts "==  Data: generating base data ".ljust(79, "=")

    GroupAssignment.destroy_all
    ConcretePackageVersion.destroy_all
    PackageVersion.destroy_all
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
    Distribution.destroy_all
    Repository.destroy_all
    ConcretePackageState.destroy_all

    unassigned         = SystemGroup.create( { :name => "Unassigned-System", :permission_level => 1 } )
    default            = SystemGroup.create( { :name => "Default-System",    :permission_level => 1 } )
    db                 = SystemGroup.create( { :name => "DB-System",         :permission_level => 6 } )
    ha                 = SystemGroup.create( { :name => "HA-System",         :permission_level => 7 } )

    uncrit             = PackageGroup.create( { :name => "Uncritical",  :permission_level => 1 } )
    crit               = PackageGroup.create( { :name => "Critical",    :permission_level => 5 } )
    dbcrit             = PackageGroup.create( { :name => "DB Critical", :permission_level => 6 } )
    hacrit             = PackageGroup.create( { :name => "HA Critical", :permission_level => 7 } )

    update_available   = ConcretePackageState.create( { :name => "Available" } )
    update_queued      = ConcretePackageState.create( { :name => "Queued for Installation" } )
    update_failed      = ConcretePackageState.create( { :name => "Failed" } )
    update_outdated    = ConcretePackageState.create( { :name => "Outdated" } )
    update_installed   = ConcretePackageState.create( { :name => "Installed" } )

    task_pending       = TaskState.create( { :name => "Pending" } )
    task_not_delivered = TaskState.create( { :name => "Not Delivered" } )
    task_queued        = TaskState.create( { :name => "Queued" } )
    task_failed        = TaskState.create( { :name => "Failed" } )
    task_done          = TaskState.create( { :name => "Done" } )

    admin              = Role.create( { :name => "Admin", :permission_level => 9, :is_user_manager => true } )
    readonly           = Role.create( { :name => "Readonly", :permission_level => 0 } )

    adminUser          = User.create( { :name => "admin", :email => "admin", :role => admin, :password => "RF9wRF9w", :password_confirmation => "RF9wRF9w" } )
    pchriste           = User.create( { :name => "pchriste", :email => "pchriste@upd89.org", :role => admin, :password => "nW3jnW3j", :password_confirmation => "nW3jnW3j" } )
    ubosshar           = User.create( { :name => "ubosshar", :email => "ubosshar@upd89.org",:role => admin, :password => "3v5Z3v5Z", :password_confirmation => "3v5Z3v5Z" } )
    sasie              = User.create( { :name => "sasie", :email => "sasie@upd89.org",:role => admin, :password => "i6Lpi6Lp", :password_confirmation => "i6Lpi6Lp" } )
    roland             = User.create( { :name => "roland", :email => "roland@upd89.org",:role => admin, :password => "h3M1h3M1", :password_confirmation => "h3M1h3M1" } )

    puts "==  Data: generating base data (done) ".ljust(79, "=") + "\n\n"
  end
end
