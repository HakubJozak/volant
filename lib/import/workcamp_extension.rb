module Import::WorkcampExtension
  extend ActiveSupport::Concern

  included do
    has_many :import_changes, :dependent => :delete_all
    scope :live, -> { where "state IS NULL" }
    scope :imported, -> { where "state = 'imported'" }
    scope :updated, -> { where "state = 'updated'" }
    scope :imported_or_updated, -> { where "state IS NOT NULL" }
  end

  # TODO: separate apply_changes! and import!
  def confirm_import!
    return unless imported? or updated?

    Outgoing::Workcamp.transaction do
      import_changes.each do |change|
        change.apply(self)
        change.destroy
      end

      self.state = nil
      save!
    end
  end

  def cancel_import!
    ::Workcamp.transaction do
      import_changes.destroy_all

      if imported?
        self.destroy
      elsif updated?
        self.state = nil
        self.save!
      end
    end
  end

  module ClassMethods
    def import_all!
      imported_or_updated.find_each do |wc|
        wc.confirm_import!
      end
    end

    def cancel_all_import!
      imported_or_updated.find_each do |wc|
        wc.cancel_import!
      end
    end

    def find_by_name_or_code(text)
      search = "%#{text.downcase}%"
      where('lower(name) LIKE ? or lower(code) LIKE ?', search, search).order('"begin" DESC, code ASC, name ASC').limit(15)
    end
  end

  def imported?
    self.state == 'imported'
  end

  def updated?
    self.state == 'updated'
  end
end
