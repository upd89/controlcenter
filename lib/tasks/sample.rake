#
# Sample Data, load with command: "rake db:sample_data"
#

namespace :db do
  desc "Generate sample data for developing"
  task :sample_data => :environment do

    puts "==  Data: generating sample data ".ljust(79, "=")

    SystemUpdate.destroy_all
    PackageInstallation.destroy_all
    PackageUpdate.destroy_all
    GroupAssignment.destroy_all
    Package.destroy_all
    System.destroy_all

    default = SystemGroup.first

    vm1 = System.create( { :name => "vm1", :urn => "vm1", :os => "ubuntu 14.04", :address => "127.0.0.1",
                           :last_seen => DateTime.now, :system_group => default } )
    vm2 = System.create( { :name => "vm2", :urn => "vm2", :os => "ubuntu 14.04",
                           :reboot_required => true, :system_group => default } )
    vm3 = System.create( { :name => "vm3", :urn => "vm3", :os => "ubuntu 14.04", :system_group => default } )

    vim        = Package.create( { :name => "vim", :base_version => "2:7.4.712-2ubuntu4",
                                   :architecture => "amd64", :section => "editors",
                                   :repository => "Ubuntu_wily_main",
                                   :homepage => "http://www.vim.org/",
                                   :summary => "Vi IMproved - enhanced vi editor" } )
    dnsutils   = Package.create( { :name => "dnsutils", :base_version => "1:9.9.5.dfsg-11ubuntu1",
                                   :architecture => "amd64", :section => "net",
                                   :repository => "Ubuntu_wily_main",
                                   :summary => "Clients provided with BIND" } )

    uncrit = PackageGroup.first

    GroupAssignment.create( { :package => vim, :package_group => uncrit } )
    GroupAssignment.create( { :package => dnsutils, :package_group => uncrit } )

    PackageInstallation.create( { :system => vm1, :package => vim, :installed_version => "2:7.4.712-2ubuntu4" } )
    PackageInstallation.create( { :system => vm1, :package => dnsutils, :installed_version => "1:9.9.5.dfsg-11ubuntu1.2" } )

    vim_upd      = PackageUpdate.create( { :package => vim, :repository => "Ubuntu_wily-updates_main",
                                           :candidate_version => "2:7.4.712-2ubuntu666" } )
    dnsutils_upd = PackageUpdate.create( { :package => dnsutils, :repository => "Ubuntu_wily-updates_main",
                                           :candidate_version => "1:9.9.5.dfsg-11ubuntu1.3" } )

    update_available = SystemUpdateState.first
    update_queued = SystemUpdateState.second

    SystemUpdate.create( { :system => vm1, :package_update => vim_upd , :system_update_state => update_available } )
    SystemUpdate.create( { :system => vm1, :package_update => dnsutils_upd, :system_update_state => update_queued } )

    puts "==  Data: generating sample data (done) ".ljust(79, "=") + "\n\n"
  end
end
