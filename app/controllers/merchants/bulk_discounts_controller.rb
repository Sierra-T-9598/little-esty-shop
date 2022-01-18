class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = HolidaysFacade.get_holidays
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

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.update(discount_params)
    redirect_to merchant_bulk_discount_path(bulk_discount.merchant_id, bulk_discount.id)
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.delete(params[:id])
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold, :merchant_id)
  end
end
