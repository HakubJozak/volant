class StatisticsController < ApplicationController
  def show
    # json = if params[:name] == 'recent30'
    #        else
    #        end
    if params[:name] == 'outgoing'
      today = Date.today
      year = params[:year].to_i
      year = today.year unless year > 0

      render json: {
        applyFormCounts: applyFormCounts(year),
        onProject: apply_forms.joins(:current_workcamp).on_project.count,
        returns: apply_forms.joins(:current_workcamp).returns_between(today,today + 7.days).count,
        leaves: apply_forms.joins(:current_workcamp).leaves_between(today,today + 7.days).count,
        news: apply_forms.just_submitted.count
      }
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
    counts = apply_forms.year(year).group('extract(month from created_at)').count
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
    stats = apply_forms.group('date(created_at)').where('created_at >= ?',30.days.ago).count
    data = []
    labels = []

    (30.days.ago.to_date..Date.today).each do |date|
      data << stats[date] || 0
      labels << date
    end

    { data: data,  labels: labels }
  end

  def apply_forms
    Outgoing::ApplyForm
  end
end
