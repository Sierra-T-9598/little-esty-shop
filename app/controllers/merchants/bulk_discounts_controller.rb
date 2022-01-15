class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])

    bulk_discount = merchant.bulk_discounts.create(discount_params)
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end
end
