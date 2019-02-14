class Internal::FridayListsController < Internal::BaseController

    def index
    respond_to do |format|
      format.csv {
        search = apply_filter(workcamps.order(current_order).joins(:country))
        send_data Export::FridayList.new(search).to_csv, filename: "friday_list.csv"
      }
    end
  end

end
