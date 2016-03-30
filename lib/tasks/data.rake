namespace :db do
  desc "Generate sample data for developing"
  task :sample_data => :environment do

    puts "==  Data: generating sample data ".ljust(79, "=")

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

    default = SystemGroup.create( { :name => "Default-System" } )
    ha = SystemGroup.create( { :name => "HA-System" } )
    db = SystemGroup.create( { :name => "DB-System" } )

    vm1 = System.create( { :name => "vm1", :urn => "vm1", :os => "ubuntu 14.04", :system_group => default } )
    vm2 = System.create( { :name => "vm2", :urn => "vm2", :os => "ubuntu 14.04", :system_group => default } )
    vm3 = System.create( { :name => "vm3", :urn => "vm3", :os => "ubuntu 14.04", :system_group => db } )

    uncrit = PackageGroup.create( { :name => "Uncritical" } )
    crit   = PackageGroup.create( { :name => "Critical" } )
    dbcrit = PackageGroup.create( { :name => "DB Critical" } )
    hacrit = PackageGroup.create( { :name => "HA Critical" } )

    vim        = Package.create( { :name => "vim" } )
    apache2    = Package.create( { :name => "apache2" } )
    postfix    = Package.create( { :name => "postfix" } )
    exim       = Package.create( { :name => "exim" } )
    cron       = Package.create( { :name => "cron" } )

    GroupAssignment.create( { :package => vim, :package_group => uncrit } )
    PackageInstallation.create( { :system => vm1, :package => vim } )
    vim_upd = PackageUpdate.create( { :package => vim } )
    SystemUpdate.create( { :system => vm1, :package_update => vim_upd } )

    admin  =  Role.create( { :name => "Admin" } )
    readonly  =  Role.create( { :name => "Readonly" } )
    ueli      =  User.create( { :name => "Ueli", :role => admin } )

    puts "==  Data: generating sample data (done) ".ljust(79, "=") + "\n\n"
  end
end
