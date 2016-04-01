#
# Sample Data, load with command: "rake db:sample_data"
#

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

    unasigned        = SystemGroup.create( { :name => "Unasigned-System",:permission_level => 1 } )
    default          = SystemGroup.create( { :name => "Default-System",  :permission_level => 1 } )
    db               = SystemGroup.create( { :name => "DB-System",       :permission_level => 6 } )
    ha               = SystemGroup.create( { :name => "HA-System",       :permission_level => 7 } )

    uncrit           = PackageGroup.create( { :name => "Uncritical",  :permission_level => 1 } )
    crit             = PackageGroup.create( { :name => "Critical",    :permission_level => 5 } )
    dbcrit           = PackageGroup.create( { :name => "DB Critical", :permission_level => 6 } )
    hacrit           = PackageGroup.create( { :name => "HA Critical", :permission_level => 7 } )

    update_available = SystemUpdateState.create( { :name => "Available" } ) 
    update_queued    = SystemUpdateState.create( { :name => "Queued for installation" } ) 
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

    vm1 = System.create( { :name => "vm1", :urn => "vm1", :os => "ubuntu 14.04", :address => "127.0.0.1",
                           :last_seen => DateTime.now, :system_group => default } )
    vm2 = System.create( { :name => "vm2", :urn => "vm2", :os => "ubuntu 14.04",
                           :reboot_required => true, :system_group => default } )
    vm3 = System.create( { :name => "vm3", :urn => "vm3", :os => "ubuntu 14.04", :system_group => db } )

    vim        = Package.create( { :name => "vim", :base_version => "2:7.4.712-2ubuntu4",
                                   :architecture => "amd64", :section => "editors",
                                   :repository => "Ubuntu_wily_main",
                                   :homepage => "http://www.vim.org/",
                                   :summary => "Vi IMproved - enhanced vi editor" } )
    dnsutils   = Package.create( { :name => "dnsutils", :base_version => "1:9.9.5.dfsg-11ubuntu1",
                                   :architecture => "amd64", :section => "net",
                                   :repository => "Ubuntu_wily_main",
                                   :summary => "Clients provided with BIND" } )

    GroupAssignment.create( { :package => vim, :package_group => uncrit } )
    GroupAssignment.create( { :package => dnsutils, :package_group => uncrit } )

    PackageInstallation.create( { :system => vm1, :package => vim, :installed_version => "2:7.4.712-2ubuntu4" } )
    PackageInstallation.create( { :system => vm1, :package => dnsutils, :installed_version => "1:9.9.5.dfsg-11ubuntu1.2" } )

    vim_upd      = PackageUpdate.create( { :package => vim, :repository => "Ubuntu_wily-updates_main",
                                           :candidate_version => "2:7.4.712-2ubuntu666" } )
    dnsutils_upd = PackageUpdate.create( { :package => dnsutils, :repository => "Ubuntu_wily-updates_main",
                                           :candidate_version => "1:9.9.5.dfsg-11ubuntu1.3" } )

    SystemUpdate.create( { :system => vm1, :package_update => vim_upd , :system_update_state => update_available } )
    SystemUpdate.create( { :system => vm1, :package_update => dnsutils_upd, :system_update_state => update_queued } )

    puts "==  Data: generating sample data (done) ".ljust(79, "=") + "\n\n"
  end
end
