class StatisticsController < ApplicationController
  def show
    stats = Outgoing::ApplyForm.group('date(created_at)').where('created_at >= ?',30.days.ago).count
    data = []
    labels = []

    (30.days.ago.to_date..Date.today).each do |date|
      data << stats[date] || 0
      labels << date
    end

    json = {
      data: data,
      labels: labels
    }

    render json: { recentApplyForms: json}
  end
end
