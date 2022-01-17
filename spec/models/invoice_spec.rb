require 'rails_helper'

RSpec.describe Invoice do
  describe 'relations' do
    it { should belong_to :customer }
    it { should have_many :transactions}
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_id)}
    it { should define_enum_for(:status).with_values([:cancelled, :completed, 'in progress']) }
  end

  let!(:merchant_1) {Merchant.create!(name: 'Ron Swanson')}
  let!(:merchant_2) {Merchant.create!(name: 'Bella Donna')}

  let!(:item_1) {merchant_1.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 350)}
  let!(:item_2) {merchant_1.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 200)}
  let!(:item_3) {merchant_2.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)}
  let!(:item_4) {merchant_2.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 150)}

  let!(:customer_1) {Customer.create!(first_name: "Billy", last_name: "Joel")}

  let!(:invoice_1) {customer_1.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')}
  let!(:invoice_2) {customer_1.invoices.create!(status: 1, created_at: '2012-02-25 09:54:09')}
  let!(:invoice_3) {customer_1.invoices.create!(status: 1, created_at: '2012-01-25 09:54:09')}

  let!(:invoice_item_1) {InvoiceItem.create!(quantity: 3, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice_1.id, status: 0)}
  let!(:invoice_item_2) {InvoiceItem.create!(quantity: 5, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice_1.id, status: 0)}
  let!(:invoice_item_3) {InvoiceItem.create!(quantity: 1, unit_price: item_3.unit_price, item_id: item_3.id, invoice_id: invoice_1.id, status: 0)}
  let!(:invoice_item_4) {InvoiceItem.create!(quantity: 1, unit_price: item_3.unit_price, item_id: item_3.id, invoice_id: invoice_2.id, status: 1)}
  let!(:invoice_item_5) {InvoiceItem.create!(quantity: 1, unit_price: item_3.unit_price, item_id: item_3.id, invoice_id: invoice_3.id, status: 2)}

  describe 'instance methods' do
    describe '#creation_date_formatted' do
      it 'converts the invoice item invoice creation date to DAY, MM DD, YYYY' do
        expect(invoice_1.creation_date_formatted).to eq('Sunday, March 25, 2012')
      end
    end

    describe '#items_by_merchant' do
      it 'returns all item objects associated with invoice for a specific merchant id' do
        expect(invoice_1.items_by_merchant(merchant_1.id)).to eq([item_1, item_2])
        expect(invoice_1.items_by_merchant(merchant_1.id)).to_not include(item_3)
      end
    end

    describe '#total_revenue_by_merchant' do
      it 'multiplies unit price by quantity of item on invoice and adds together to return total revenue for specific merchant' do
        total_revenue = (invoice_item_1.unit_price * invoice_item_1.quantity) + (invoice_item_2.unit_price * invoice_item_2.quantity)

        expect(invoice_1.total_revenue_by_merchant(merchant_1.id)).to eq(total_revenue)
      end
    end

    describe '#discount_items' do
      it 'returns list of items that qualify for discount on an invoice, no items qualify (EX 1)' do
        merchant = Merchant.create!(name: 'Shakey Graves')
        discount = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        item_1 = merchant.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)
        item_2 = merchant.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        customer = Customer.create!(first_name: 'Nathaniel', last_name: 'Rateliff')
        invoice = customer.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
        invoice_item_1 = InvoiceItem.create!(quantity: 5, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice.id, status: 2)
        invoice_item_2 = InvoiceItem.create!(quantity: 5, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice.id, status: 2)

        expect(invoice.discount_items).to eq([])
      end
    end

    describe '#total_discount' do
      it 'calculates the total disount amount of an invoice, only one item qualifies (EX 2)' do
        merchant = Merchant.create!(name: 'Shakey Graves')
        discount_1 = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount_2 = merchant.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 8)
        item_1 = merchant.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)
        item_2 = merchant.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        customer = Customer.create!(first_name: 'Nathaniel', last_name: 'Rateliff')
        invoice = customer.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
        invoice_item_1 = InvoiceItem.create!(quantity: 10, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice.id, status: 2)
        invoice_item_2 = InvoiceItem.create!(quantity: 5, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice.id, status: 2)
        expect(invoice.total_discount).to eq(2000)
      end

      it 'applies the highest discount that a bulk order of an item qualifies for (EX 3)' do
        merchant = Merchant.create!(name: 'Shakey Graves')
        discount_1 = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount_2 = merchant.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
        item_1 = merchant.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)
        item_2 = merchant.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        customer = Customer.create!(first_name: 'Nathaniel', last_name: 'Rateliff')
        invoice = customer.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
        invoice_item_1 = InvoiceItem.create!(quantity: 12, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice.id, status: 2)
        invoice_item_2 = InvoiceItem.create!(quantity: 15, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice.id, status: 2)
        expect(invoice.total_discount).to eq(4650)
      end

      it 'can have a discount that no items get (EX 4)' do
        merchant = Merchant.create!(name: 'Shakey Graves')
        discount_1 = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount_2 = merchant.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 15)
        item_1 = merchant.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)
        item_2 = merchant.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        customer = Customer.create!(first_name: 'Nathaniel', last_name: 'Rateliff')
        invoice = customer.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
        invoice_item_1 = InvoiceItem.create!(quantity: 12, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice.id, status: 2)
        invoice_item_2 = InvoiceItem.create!(quantity: 15, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice.id, status: 2)
        expect(invoice.total_discount).to eq(3900)
      end

      it 'can have items from another merchant that do not get discounted (EX 5)' do
        merchant_1 = Merchant.create!(name: 'Shakey Graves')
        merchant_2 = Merchant.create!(name: 'Gregory Alan Isakov')
        discount_1 = merchant_1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount_2 = merchant_1.bulk_discounts.create!(percentage_discount: 30, quantity_threshold: 15)
        item_1 = merchant_1.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)
        item_2 = merchant_1.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        item_3 = merchant_2.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        customer = Customer.create!(first_name: 'Nathaniel', last_name: 'Rateliff')
        invoice = customer.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
        invoice_item_1 = InvoiceItem.create!(quantity: 12, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice.id, status: 2)
        invoice_item_2 = InvoiceItem.create!(quantity: 15, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice.id, status: 2)
        invoice_item_3 = InvoiceItem.create!(quantity: 15, unit_price: item_3.unit_price, item_id: item_3.id, invoice_id: invoice.id, status: 2)
        expect(invoice.total_discount).to eq(4650)
      end
    end

    describe '#total_discounted_revenue' do
      it 'calculates the total revenue including discounts' do
        merchant = Merchant.create!(name: 'Shakey Graves')
        discount_1 = merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount_2 = merchant.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 8)
        item_1 = merchant.items.create!(name: "Necklace", description: "A thing around your neck", unit_price: 1000)
        item_2 = merchant.items.create!(name: "Bracelet", description: "A thing around your wrist", unit_price: 500)
        customer = Customer.create!(first_name: 'Nathaniel', last_name: 'Rateliff')
        invoice = customer.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
        invoice_item_1 = InvoiceItem.create!(quantity: 10, unit_price: item_1.unit_price, item_id: item_1.id, invoice_id: invoice.id, status: 2)
        invoice_item_2 = InvoiceItem.create!(quantity: 5, unit_price: item_2.unit_price, item_id: item_2.id, invoice_id: invoice.id, status: 2)
        expect(invoice.total_discounted_revenue).to eq(10500)
      end
    end
  end

  describe 'class methods' do
    describe '.incomplete_invoices' do
      it 'returns invoices only with items that are packaged or pending' do
        expect(Invoice.incomplete_invoices).to eq([invoice_2, invoice_1])
        expect(Invoice.incomplete_invoices).to_not include(invoice_3)
      end
    end
  end
end
