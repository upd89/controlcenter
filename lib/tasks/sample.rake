#
# Sample Data, load with command: "rake db:sample_data"
#

namespace :db do
  desc "Generate sample data for developing"
  task :sample_data => :environment do

    puts "==  Data: generating sample data ".ljust(79, "=")

    ConcretePackageVersion.destroy_all
    PackageVersion.destroy_all
    GroupAssignment.destroy_all
    Package.destroy_all
    Repository.destroy_all
    Distribution.destroy_all
    System.destroy_all

    default = SystemGroup.first

    vm1 = System.create( { :name => "vm1",
                           :urn => "vm1",
                           :os => "ubuntu 14.04",
                           :address => "127.0.0.1",
                           :last_seen => DateTime.now,
                           :system_group => default } )
    vm2 = System.create( { :name => "vm2",
                           :urn => "vm2",
                           :os => "ubuntu 14.04",
                           :address => "1.2.3.4",
                           :last_seen => 10.minutes.ago,
                           :reboot_required => true,
                           :system_group => default } )
    vm3 = System.create( { :name => "vm3",
                           :urn => "vm3",
                           :os => "ubuntu 14.04",
                           :address => "5.6.7.8",
                           :last_seen => 30.minutes.ago,
                           :system_group => default } )

    vim        = Package.create( { :name => "vim",
                                   :section => "editors",
                                   :homepage => "http://www.vim.org/",
                                   :summary => "Vi IMproved - enhanced vi editor" } )
    dnsutils   = Package.create( { :name => "dnsutils",
                                   :section => "net",
                                   :summary => "Clients provided with BIND" } )

    uncrit = PackageGroup.first

    GroupAssignment.create( { :package => vim, :package_group => uncrit } )
    GroupAssignment.create( { :package => dnsutils, :package_group => uncrit } )

    repo = Repository.create( { :origin => "Foo", :archive => "Bar", :component => "Baz" } )

    dist = Distribution.create( { :name => "FooBarRepo" } )

    vim_base      = PackageVersion.create( { :package => vim,
                                             :repository => repo,
                                             :sha256 => "be71358f6e29cd3defeeaa583fdf5cfbbc05f104027f939f6bdb1918b548bce9",
                                             :version => "2:7.4.1-2ubuntu666",
                                             :is_base_version => true,
                                             :architecture => "amd64",
                                             :distribution => dist } )
    dnsutils_base = PackageVersion.create( { :package => dnsutils,
                                             :repository => repo,
                                             :sha256 => "20cd8d7855d00d1bf54ac16fd54d74f5c2ad1b1324221aa1896fc38c7cb8a22f",
                                             :version => "1:9.9.1.dfsg-11ubuntu1.3",
                                             :is_base_version => true,
                                             :architecture => "amd64",
                                             :distribution => dist } )
    vim_upd       = PackageVersion.create( { :package => vim,
                                             :repository => repo,
                                             :sha256 => "d391f11b3b9f8ced025dfd5e1423d15ee2f90e7c71b9bd1c8d7737677211122e",
                                             :version => "2:7.4.712-2ubuntu666",
                                             :is_base_version => false,
                                             :architecture => "amd64",
                                             :distribution => dist } )
    dnsutils_upd  = PackageVersion.create( { :package => dnsutils,
                                             :repository => repo,
                                             :sha256 => "64ab8908be1c0d955ad0cc47f4010aa8f309f3afd89a6898362c212ebfb65075",
                                             :version => "1:9.9.5.dfsg-11ubuntu1.3",
                                             :is_base_version => false,
                                             :architecture => "amd64",
                                             :distribution => dist } )

    update_installed = ConcretePackageState.last
    update_available = ConcretePackageState.first
    update_queued = ConcretePackageState.second

    ConcretePackageVersion.create( { :system => vm1, :package_version => vim_base , :concrete_package_state => update_installed } )
    ConcretePackageVersion.create( { :system => vm1, :package_version => vim_upd , :concrete_package_state => update_available } )
    ConcretePackageVersion.create( { :system => vm1, :package_version => dnsutils_base, :concrete_package_state => update_installed } )
    ConcretePackageVersion.create( { :system => vm1, :package_version => dnsutils_upd, :concrete_package_state => update_queued } )

    puts "==  Data: generating sample data (done) ".ljust(79, "=") + "\n\n"
  end
end
