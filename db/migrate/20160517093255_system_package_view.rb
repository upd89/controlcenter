class SystemPackageView < ActiveRecord::Migration
  def change
    self.connection.execute %Q( CREATE OR REPLACE VIEW system_package_relation AS
    SELECT   packages.id as pkg_id,
             packages.name as pkg_name,
             packages.section as pkg_section,
             packages.summary as pkg_summary,
             package_versions.id as version_id,
             package_versions.version,
             concrete_package_states.name as state,
             systems.id as sys_id,
             systems.name as sys_name,
             systems.urn as sys_urn,
             systems.address as sys_address,
             systems.reboot_required as sys_reboot_required,
             systems.os as sys_os,
             systems.system_group_id as sys_grp_id
        FROM packages
        JOIN package_versions ON packages.id = package_versions.package_id
        JOIN concrete_package_versions ON package_versions.id = concrete_package_versions.package_version_id
        JOIN concrete_package_states ON concrete_package_versions.concrete_package_state_id = concrete_package_states.id
        JOIN systems ON concrete_package_versions.system_id = systems.id
        WHERE concrete_package_states.name = 'Available' ;
    )
  end
end
