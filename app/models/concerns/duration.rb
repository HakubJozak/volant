module DurationConcern
  extend ActiveSupport::Concern

  DURATION_SQL = '(EXTRACT(epoch FROM age("end","begin"))/(3600 * 24))'
  
  included do
    before_save :set_computed_duration
    scope :min_duration, lambda { |d| where("(duration IS NULL AND #{DURATION_SQL} >= ?) OR duration >= ?", d,d) }
    scope :max_duration, lambda { |d| where("(duration IS NULL AND #{DURATION_SQL} <= ?) OR duration <= ?", d) }
  end

  def duration
    read_attribute(:duration) || computed_duration
  end

  private

  def computed_duration
    if self.end and self.begin
      (self.end.to_time - self.begin.to_time).to_i / 1.day + 1
    else
      nil
    end
  end
  
  
end
