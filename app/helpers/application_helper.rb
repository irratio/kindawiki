module ApplicationHelper
  def page_title
    if @page.present? && @page.title.present?
      "#{@page.title} — Kindawiki"
    else
      'Kindawiki'
    end
  end
end
