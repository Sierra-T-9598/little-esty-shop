class Invoice < ApplicationRecord
  enum status: ["cancelled", "completed", "in progress"]

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates_presence_of :customer_id

  def creation_date_formatted
    date = self.created_at
    date.strftime("%A, %B %d, %Y")
  end

  def items_by_merchant(merchant_id)
    items.joins(:invoice_items)
         .where('merchant_id = ?', merchant_id)
  end

  def total_revenue_by_merchant(merchant_id)
    items_by_merchant(merchant_id)
    .pluck(Arel.sql("invoice_items.unit_price * invoice_items.quantity"))
    .sum
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not('invoice_items.status = ?', 2)
    .select('invoices.*')
    .group('invoices.id')
    .order(:created_at)
  end

  def discount_items
    invoice_items.joins(:bulk_discounts)
    .select("invoice_items.*, bulk_discounts.id as discount, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percentage_discount / 100.0)) as total_discount")
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group("invoice_items.id, discount")
    .order(total_discount: :desc)
  end
end
