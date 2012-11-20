module ApplicationHelper
  def sortable(model, column, title = nil)
    title ||= column.titleize
    sort_col = sort_column model
    css_class = column == sort_col ? "current sorting_#{sort_direction}" : "sorting"
    direction = column == sort_col && sort_direction == "asc" ? "desc" : "asc"
    # raw "<div class='#{css_class}'>#{link_to(title, params.merge(:sort => column, :direction => direction, :page => nil))}</div>"
    return title
  end

  def sort_column(model)
    model.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def seconds_in_human seconds
    (Time.mktime(0) + seconds).strftime("%H:%M")
  end
end

