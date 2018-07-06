class FamilyDishesController < ApplicationController
  before_action :set_family_dish, only: [:show, :edit, :update, :destroy]

  # GET /family_dishes
  # GET /family_dishes.json
  def index
    if params[:family_id] != nil
      @family_dishes = FamilyDish.where(family_id: params[:family_id])
    else
      @family_dishes = FamilyDish.all
    end
    respond_to do |format|
      format.html
      format.json { render :json => @family_dishes }
    end
  end

  # POST /family_dishes
  # POST /family_dishes.json
  def create
    @family_dish = FamilyDish.new(family_dish_params)

    respond_to do |format|
      if @family_dish.save
        format.html { redirect_to @family_dish, notice: 'Dish was successfully created.' }
        format.json { render json: @family_dish, status: :created }
      else
        format.html { render :new }
        format.json { render json: @family_dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_dishes/1
  # PATCH/PUT /family_dishes/1.json
  def update
    respond_to do |format|
      if @family_dish.update(family_dish_params)
        format.html { redirect_to @family_dish, notice: 'Family member was successfully updated.' }
        format.json { render json: @family_dish, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @family_dish.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_dish
      @family_dish = FamilyDish.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_dish_params
      params.require(:family_dish).permit(:parent_id,:family_id,:name,:description,:is_favorite,:comfort_level,:health_level,:cooking_difficulty,:is_prepared_ahead,:prep_time_minutes,:cooking_time_minutes,:serving_size,:protein_grams,:calories)
    end
end
