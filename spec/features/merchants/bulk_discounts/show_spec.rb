require 'rails_helper'

RSpec.describe 'Bulk Discounts Show' do
  let!(:merchant_1) {Merchant.create!(name: 'Ron Swanson')}
  let!(:merchant_2) {Merchant.create!(name: 'Jon Swanson')}

  let!(:discount_1) {merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 25)}
  let!(:discount_2) {merchant_1.bulk_discounts.create!(percentage_discount: 50, quantity_threshold: 100)}
  let!(:discount_3) {merchant_1.bulk_discounts.create!(percentage_discount: 10, quantity_threshold: 10)}
  let!(:discount_4) {merchant_2.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 21)}

  let!(:item_1) {merchant_1.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 100, status: 0)}
  let!(:item_2) {merchant_1.items.create!(name: "Bracelet", description: "A thing around your neck", unit_price: 100, status: 0)}
  let!(:item_3) {merchant_1.items.create!(name: "Earrings", description: "A thing around your neck", unit_price: 100, status: 0)}
  let!(:item_4) {merchant_1.items.create!(name: "Gauges", description: "A thing around your neck", unit_price: 100, status: 1)}
  let!(:item_5) {merchant_1.items.create!(name: "Plants", description: "A thing around your neck", unit_price: 100)}

  let!(:customer_1) {Customer.create!(first_name: "Billy", last_name: "Joel")}
  let!(:customer_2) {Customer.create!(first_name: "Britney", last_name: "Spears")}

  let!(:invoice_1) {customer_1.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')}
  let!(:invoice_2) {customer_1.invoices.create!(status: 1, created_at: '2012-04-25 08:54:09')}
  let!(:invoice_3) {customer_2.invoices.create!(status: 1, created_at: '2012-10-25 04:54:09')}
  let!(:invoice_4) {customer_2.invoices.create!(status: 1, created_at: '2012-03-26 01:54:09')}

  let!(:invoice_item_1) {InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, unit_price: item_1.unit_price, quantity: 2, status: 0)}
  let!(:invoice_item_2) {InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, unit_price: item_2.unit_price, quantity: 2, status: 0)}
  let!(:invoice_item_3) {InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_3.id, unit_price: item_3.unit_price, quantity: 2, status: 0)}
  let!(:invoice_item_4) {InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_4.id, unit_price: item_4.unit_price, quantity: 2, status: 1)}

  let!(:transaction_1) {invoice_1.transactions.create!(result: 'success')}
  let!(:transaction_2) {invoice_2.transactions.create!(result: 'success')}
  let!(:transaction_3) {invoice_3.transactions.create!(result: 'success')}
  let!(:transaction_4) {invoice_4.transactions.create!(result: 'success')}

  before(:each) do
    visit merchant_bulk_discount_path(merchant_1.id, discount_1.id)
  end

  scenario 'merchant sees the given bulk discount as its percentage discount and quantity threshold' do
    expect(page).to have_content(discount_1.percentage_discount)
    expect(page).to have_content(discount_1.quantity_threshold)

    expect(page).to_not have_content(discount_2.percentage_discount)
    expect(page).to_not have_content(discount_2.quantity_threshold)
  end
end
