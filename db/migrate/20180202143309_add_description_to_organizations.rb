class AddDescriptionToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :description, :text

    inex = ::Organization.find_by_code('SDA')
    inex.update_column :description, "INEX-SDA is a Czech non-governmental, non-profit organisation, founded in 1991. Our primary activities are aimed at the area of international voluntary work. We believe in volunteering and individual initiative, in direct experience and critical thinking, in understanding and respect towards diversity and in personal responsibility and sustainable development."
  end
end
