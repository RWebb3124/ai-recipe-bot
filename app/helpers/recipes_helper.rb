module RecipesHelper
  def format_amount(value, precision: 2)
    number_with_precision(value, precision: precision, strip_insignificant_zeros: true)
  end
end
