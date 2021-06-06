require 'csv'

class LoadCSVService
  attr_reader :headers, :path, :file_name

  def initialize(file_path, brand = 'Производитель', code = 'Артикул', stock = 'Количество', cost = 'Цена', name = 'Наименование')
    @path = file_path
    @file_name = @path.split('/').last
    @headers = { brand: brand, code: code, stock: stock, cost: cost, name: name}
  end

  def call
    delete_old_data
    CSV.foreach(@path, headers: true, encoding: 'ISO-8859-5', col_sep: ';') do |row|
      data_hash = row.to_h
      data_hash[brand].downcase.capitalize
      data_hash[code].downcase
      data_hash[stock].gsub(/^\d/,'').to_i
      data_hash[cost].to_f
      import_data(data_hash)
    end
  end

  private

  def code
    @headers[:code]
  end

  def brand
    @headers[:brand]
  end

  def stock
    @headers[:stock]
  end

  def cost
    @headers[:cost]
  end

  def name
    @headers[:name]
  end

  def delete_old_data
    Product.with_price_list(@file_name)&.delete_all
  end

  def find_data_with_code_brand(data_hash)
    Product.find_by( code: data_hash[code], brand: data_hash[brand], price_list: @file_name)
  end

  def import_data(data_hash)
    result = find_data_with_code_brand(data_hash)

    if result
      product = result
    else
      product = Product.new(price_list: @file_name, code: data_hash[code], brand: data_hash[brand])
    end

    product.stock = data_hash[stock]
    product.cost = data_hash[cost]
    product.name = data_hash[name]
    product.save
  end
end
