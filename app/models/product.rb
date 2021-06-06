class Product < ApplicationRecord

  validates :brand, :code, :stock, :cost, presence: true
  validates :cost, numericality: true
  validates :stock, numericality: { only_integer: true}
  validates :price_list, uniqueness: { scope: %i[code brand] }

  scope :with_price_list, -> (price_list) { where(price_list: price_list)}

end
