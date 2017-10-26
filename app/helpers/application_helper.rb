module ApplicationHelper
  def readable_date(date)
    ("<span class='date'>" + date.strftime("%b %Y") + "</span>").html_safe
  end

  def last_4(integer)
      (integer[-4..-1]).html_safe
  end # last_4

  def unit_cost(item)
    item.product.price * item.quantity
  end

  def submitted(date)
    ("<span class='date'>" + date.strftime("%b %d, %Y") + "</span>").html_safe
  end
end
