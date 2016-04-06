require "administrate/base_dashboard"

class SystemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    system_group: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    urn: Field::String,
    os: Field::String,
    reboot_required: Field::Boolean,
    address: Field::String,
    last_seen: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    system_updates: Field::HasMany
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :system_group,
    :id,
    :name,
    :urn,
    :system_updates
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :system_group,
    :id,
    :name,
    :urn,
    :os,
    :reboot_required,
    :address,
    :last_seen,
    :created_at,
    :updated_at,
    :system_updates
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :system_group,
    :name,
    :urn,
    :os,
    :reboot_required,
    :address,
    :last_seen,
  ]

  # Overwrite this method to customize how systems are displayed
  # across all pages of the admin dashboard.
  #
   def display_resource(system)
     "#{system.name}"
   end
end
