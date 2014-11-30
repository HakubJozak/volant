class ImportChange < ActiveRecord::Base

  belongs_to :workcamp, :class_name => 'Outgoing::Workcamp'
  before_save :regenerate_diff



  def apply!
    ImportChange.transaction do
      self.apply
      self.destroy
    end
  end

  def apply(wc = self.workcamp)
    wc.send("#{self.field}=", self.value.to_s)
  end

  def regenerate_diff
    Differ.format = :html
    self.diff = Differ.diff_by_word(ERB::Util.html_escape(new.to_s),
                                    ERB::Util.html_escape(old.to_s)).to_s
  end

  def old
    workcamp.send(field)
  end

  def new
    value
  end

  module Maker
    IGNORED_ATTR = [ :created_at, :updated_at, :state ].freeze

    def create_by_diff(wc)
      proxy_association.owner.diff(wc).each do |field, value|
        unless IGNORED_ATTR.include?(field)
          self.build :field => field.to_s, :value => value.last
        end
      end

      self
    end
  end
end
