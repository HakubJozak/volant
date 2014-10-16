class Paginator < Kaminari::Helpers::Paginator
  def initialize(scope,opts = {})
    # `nil` for template param because we don't need rendering
    opts = opts.merge(current_page: scope.current_page,
                      total_pages: scope.total_pages,
                      per_page: scope.limit_value)
    super(nil,opts)
  end

  def pagination_bits
    pages = self.each_relevant_page {}
    add_ellipsis(pages)
  end

  private

  # Adds '...' in the gaps between page numbers:
  #
  #     [1,2,3,10] => [1,2,3,'...',10]
  #
  def add_ellipsis(array)
    last = array[0] - 1

    array.map do |p|
      if p == last + 1
        last = p
        p
      else
        last = p
        ['...',p]
      end
    end.flatten
  end


end
