class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Everyone can read any system
    # Only users with roles with a permission level higher than a system's group's permission level can edit or delete a system
    # Nobody can create a system manually, only possible via API
    can :read, System
    can [ :update, :destroy ], System do |sys|
      sys.system_group.permission_level <= user.role.permission_level
    end
    cannot :create, System

    # Everyone can read and create any system group
    # Only users with roles with a permission level higher than a system group's permission level can edit or delete a system group
    can [ :read, :create ], SystemGroup
    can [ :update, :destroy ], SystemGroup do |sys_grp|
      sys_grp.permission_level <= user.role.permission_level
    end

    # Everyone can read any package
    # Only users with roles with a permission level higher than a package's group's permission level can edit or delete a package
    # Nobody can create a package manually, only possible via API
    can :read, Package
    can [ :update, :destroy ], Package do |pkg|
      pkg.get_permission_level <= user.role.permission_level
    end
    cannot :create, Package

    # Everyone can read and create any package group
    # Only users with roles with a permission level higher than a package group's permission level can edit or delete a package group
    can [ :read, :create ], PackageGroup
    can [ :update, :destroy ], PackageGroup do |pkg_grp|
      pkg_grp.permission_level <= user.role.permission_level
    end

    # Everyone can read any user
    # Only user manager roles can edit, create or delete a user
    can :read, User
    can [ :create, :update, :destroy ], User do |concerned_user|
      user.role.is_user_manager
    end

    # Everyone can read any role
    # Only user manager roles can edit, create or delete a role
    can :read, Role
    can [ :create, :update, :destroy ], Role do
      user.role.is_user_manager
    end

    can :read, TaskState
    cannot [:create, :update, :destroy], TaskState

    can :read, ConcretePackageState
    cannot [:create, :update, :destroy], ConcretePackageState

    can :read, ConcretePackageVersion
    can [ :update, :destroy ], ConcretePackageVersion do |cpv|
      cpv.system.system_group.permission_level <= user.role.permission_level && cpv.package_version.package.get_permission_level <= user.role.permission_level
    end
    cannot :create, ConcretePackageVersion

    can :read, PackageVersion
    cannot [:create, :update, :destroy], PackageVersion

    can [:read, :destroy], Job
    cannot [:create, :update], Job

    can [:read, :destroy], Task
    cannot [:create, :update], Task

    can :read, TaskExecution
    cannot [:create, :update, :destroy], TaskExecution

    can [:read, :update], Distribution
    cannot [:create, :destroy], Distribution

    can [:read, :update], Repository
    cannot [:create, :destroy], Repository
  end
end
