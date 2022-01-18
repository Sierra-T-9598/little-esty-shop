require 'rails_helper'

RSpec.describe 'Create New Bulk Discount' do

  let!(:merchant_1) { create :merchant }
  let!(:merchant_2) { create :merchant }

  let!(:discount_1) { create :bulk_discount, merchant: merchant_1 }
  let!(:discount_2) { create :bulk_discount, merchant: merchant_1 }
  let!(:discount_3) { create :bulk_discount, merchant: merchant_1 }
  let!(:discount_4) { create :bulk_discount, merchant: merchant_2 }

  scenario 'merchant fills out new dicount form' do
    expect(merchant_1.bulk_discounts.count).to eq(3)
    visit new_merchant_bulk_discount_path(merchant_1.id)
    fill_in 'Percentage discount', with: 20
    fill_in 'Quantity threshold', with: 10
    click_button "Create Discount"

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1.id))
    expect(merchant_1.bulk_discounts.count).to eq(4)
  end
end
