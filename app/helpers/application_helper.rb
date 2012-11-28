module ApplicationHelper
  def sortable(model, column, title = nil)
    title ||= column.titleize
    sort_col = sort_column model
    css_class = column == sort_col ? "current sorting_#{sort_direction}" : "sorting"
    direction = column == sort_col && sort_direction == "asc" ? "desc" : "asc"
    raw "<div class='#{css_class}'>#{link_to(title, params.merge(:sort => column, :direction => direction, :page => nil, :format => :js), :remote => true)}</div>"
  end

  def sort_column(model, default_sort_col = 'id')
    model.column_names.include?(params[:sort]) ? params[:sort] : default_sort_col
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def seconds_in_human secs
    s = []
    2.times.each do
      if secs > 0
        secs, n = secs.divmod 60
        s.unshift "#{n.to_i}"
      end
    end
    s.unshift "#{secs}" if secs > 0
    s.join(':')
    unless s.blank?
      s.join(':')
    else
      '0'
    end
  end

  def number_in_human number
    return "#{number/1000.0} K" if number > 1000
    number.to_s
  end

  def distance_from_now to
    (to - DateUtil.today).to_i
  end
end

