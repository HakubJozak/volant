module Ltv
  class Workcamp < ::Workcamp
    # TODO - cover by test
    # so that year long projects would show in the web search
    scope :future, -> {
      where('"end" >= current_date')
    }

    def open_for_application
      to.nil? || to >= Time.now.to_date
    end
  end
end
