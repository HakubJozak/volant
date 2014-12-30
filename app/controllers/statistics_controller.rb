class StatisticsController < ApplicationController
  def show
    # json = if params[:name] == 'recent30'
    #        else
    #        end
    if params[:name] == 'outgoing'
      year = params[:year].to_i
      year = Date.today.year unless year > 0
      render json: { applyFormCounts: applyFormCounts(year)}
    else
      head :not_found
    end
  end

  private

  def applyFormCounts(year)
    {
      lastYear: app_count_by_month(year - 1),
      currentYear: app_count_by_month(year)
    }
  end

  def app_count_by_month(year)
    counts = Outgoing::ApplyForm.year(year).group('extract(month from created_at)').count
    date = Date.new(2014)
    labels = []
    data = []

    12.times do
      labels << date.strftime('%B')
      data << (counts[date.month.to_f] || 0)
      date = date.next_month
    end

    { labels: labels, data: data, title: year }
  end

  def recent30
    stats = Outgoing::ApplyForm.group('date(created_at)').where('created_at >= ?',30.days.ago).count
    data = []
    labels = []

    (30.days.ago.to_date..Date.today).each do |date|
      data << stats[date] || 0
      labels << date
    end

    { data: data,  labels: labels }
  end
end
