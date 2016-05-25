class RemoveSystemPackageGroupView < ActiveRecord::Migration
  def change
    self.connection.execute %Q( DROP VIEW system_package_relation_grouped ; )
  end
end
