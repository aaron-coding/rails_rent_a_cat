class CatRentalRequestsController < ApplicationController
  def new 
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new
    render :new
  end
  
  def create
    @cat_rental_request = CatRentalRequest.new(crr_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id) 
    else
      render :new
    end
  end
  
  
  private
  def crr_params
    params.require(:cat_rental_request)
      .permit(:start_date, :end_date, :cat_id)
  end
end
