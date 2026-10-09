module SavedRecipesHelper
  def stars(rating)
    return "" if rating.blank?

    "#{'★' * rating}#{'☆' * (5 - rating)}"
  end

  def rating_options
    (1..5).map { |n| [stars(n), n] }
  end
end
