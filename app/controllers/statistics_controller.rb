class StatisticsController < ApplicationController
  def show
    all = {
      data: [28,48,40,19,96,27,-55],
      labels: ["January","February","March","April","May","June","Julyyy"]
    }

    render json: { recentApplyForms: all}
  end
end
