class SystemPackageGroupView < ActiveRecord::Migration
  def change
    self.connection.execute %Q( CREATE OR REPLACE VIEW system_package_relation_grouped AS
      SELECT packages.id as pkg_id,
             packages.name as pkg_name,
             packages.section as pkg_section,
             packages.summary as pkg_summary,
             COUNT(*) as sys_count
        FROM packages
        LEFT JOIN package_versions ON packages.id = package_versions.package_id
        LEFT JOIN concrete_package_versions ON package_versions.id = concrete_package_versions.package_version_id
        LEFT JOIN concrete_package_states ON concrete_package_versions.concrete_package_state_id = concrete_package_states.id
        LEFT JOIN systems ON concrete_package_versions.system_id = systems.id
        WHERE concrete_package_states.name = 'Available' GROUP BY packages.id;
    )
  end
end
