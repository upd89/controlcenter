#
# Base Data, load with command: "rake db:base_data"
#

namespace :db do
  desc "Generate base data"
  task :add_groups => :environment do

    puts "==  Data: generating base data ".ljust(79, "=")

    GroupAssignment.destroy_all

    unassigned         = SystemGroup.where( { :name => "Unassigned-System" } ).first
    default            = SystemGroup.where( { :name => "Default-System" } ).first
    db                 = SystemGroup.where( { :name => "DB-System" } ).first
    ha                 = SystemGroup.where( { :name => "HA-System" } ).first

    uncrit             = PackageGroup.where( { :name => "Uncritical" } ).first
    crit               = PackageGroup.where( { :name => "Critical" } ).first
    dbcrit             = PackageGroup.where( { :name => "DB Critical" } ).first
    hacrit             = PackageGroup.where( { :name => "HA Critical" } ).first


    kernel_pkgs = Package.where( { :section => "kernel" } )
    kernel_pkgs.each do | pkg |
        GroupAssignment.create( { :package_group => crit , :package => pkg } )
    end

    db_pkgs = Package.where( { :section => "database" } )
    db_pkgs.each do | pkg |
        GroupAssignment.create( { :package_group => dbcrit , :package => pkg } )
    end

    uncrit_pkgs = Package.where( :section => ["editors", "utils"] )
    uncrit_pkgs.each do | pkg |
        GroupAssignment.create( { :package_group => uncrit , :package => pkg } )
    end


    # GroupAssignment.all
    #
    # adminUser          = User.create( { :name => "admin", :email => "admin", :role => admin, :password => "testtesttest", :password_confirmation => "testtesttest" } )


    puts "==  Data: generating sample data (done) ".ljust(79, "=") + "\n\n"
  end
end
