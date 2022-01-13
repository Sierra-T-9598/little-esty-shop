require 'rails_helper'

RSpec.describe 'Admin Invoice Show page' do
  let!(:customer_1) {Customer.create!(first_name: "Billy", last_name: "Joel")}

  let!(:merchant_1) {Merchant.create!(name: 'Ron Swanson', status: 0)}

  let!(:item_1) {merchant_1.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000, status: 0)}
  let!(:item_2) {merchant_1.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 900, status: 0)}
  let!(:item_3) {merchant_1.items.create!(name: "Earrings", description: "These go through your ears", unit_price: 1500, status: 1)}

  let!(:invoice_1) {customer_1.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')}

  let!(:invoice_item_1)  {InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, unit_price: item_1.unit_price, quantity: 2, status: 0)}
  let!(:invoice_item_2)  {InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, unit_price: item_2.unit_price, quantity: 26, status: 0)}
  let!(:invoice_item_3)  {InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, unit_price: item_3.unit_price, quantity: 2, status: 0)}

  before(:each) do
    visit admin_invoice_path(invoice_1.id)
  end

  scenario 'admin sees invoice attributes' do
    expect(page).to have_content(invoice_1.id)
    expect(page).to have_content(invoice_1.creation_date_formatted)
    expect(page).to have_content(customer_1.first_name)
    expect(page).to have_content(customer_1.last_name)
  end

  scenario 'admin sees all items on invoice' do
    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_1.unit_price.to_f/100)
    expect(page).to have_content(invoice_item_1.quantity)
    expect(page).to have_content(invoice_item_3.status)
  end

  scenario 'visitor sees invoice status is a select field next to invoice with current status selected' do
    expect(page).to have_field('status', with: 'completed')
    expect(page).to have_button('Update Invoice Status')
  end

  scenario 'visitor can select new status and update by clicking submit button' do
    expect(page).to have_field('status', with: 'completed')
    expect(page).to have_button('Update Invoice Status')

    select 'Cancelled', from: 'status'
    click_button('Update Invoice Status')

    expect(current_path).to eq(admin_invoice_path(invoice_1.id))
    expect(page).to have_field('status', with: 'cancelled')

    select 'In Progress', from: 'status'
    click_button('Update Invoice Status')

    expect(current_path).to eq(admin_invoice_path(invoice_1.id))
    expect(page).to have_field('status', with: 'in progress')

    select 'Completed', from: 'status'
    click_button('Update Invoice Status')

    expect(current_path).to eq(admin_invoice_path(invoice_1.id))
    expect(page).to have_field('status', with: 'completed')
  end

  scenario 'admin sees total revenue generated from this invoice' do
    expect(page).to have_content(invoice_1.invoice_items.revenue.to_f/100)
  end
end
