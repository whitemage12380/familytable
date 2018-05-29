class FamilyDishesController < ApplicationController
  # GET /family_dishes
  # GET /family_dishes.json
  def index
    if params[:family_id] != nil
      @family_dishes = FamilyDish.where(:family_id, params[:family_id])
    else
      @family_dishes = FamilyDish.all
    end
    respond_to do |format|
      format.html
      format.json { render :json => @family_dishes }
    end
  end
end
