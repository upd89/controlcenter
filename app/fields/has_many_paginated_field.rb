require "administrate/field/base"

class HasManyPaginatedField < Administrate::Field::HasMany
  def to_s
    data
  end
end
