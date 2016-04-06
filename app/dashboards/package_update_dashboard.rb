require "administrate/base_dashboard"

class PackageUpdateDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    package: Field::BelongsTo,
    id: Field::Number,
    candidate_version: Field::String,
    repository: Field::String,
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
    :package,
    :id,
    :candidate_version,
    :repository,
    :system_updates
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :package,
    :id,
    :candidate_version,
    :repository,
    :created_at,
    :updated_at,
    :system_updates
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :package,
    :candidate_version,
    :repository,
  ]

  # Overwrite this method to customize how package updates are displayed
  # across all pages of the admin dashboard.
  #
   def display_resource(package_update)
     "#{package_update.package.name}" #todo: show version?
   end
end
