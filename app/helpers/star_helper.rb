module StarHelper
  def star_for(record)
    icon = if record.starred_by?(current_user)
            "star"
          else
            "star-o"
          end
    fa(icon)
  end

end
