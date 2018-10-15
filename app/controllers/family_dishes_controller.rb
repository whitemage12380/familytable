class FamilyDishesController < ApplicationController
  before_action :set_family_dish, only: [:show, :edit, :update, :destroy]

  # GET /family_dishes
  # GET /family_dishes.json
  def index
    if params[:family_id] != nil
      @family_dishes = FamilyDish.includes(:ingredients).where(family_id: params[:family_id])
      #@family_dishes = FamilyDish.includes(family_dish_ingredients: [:ingredient]).where(family_id: params[:family_id])
      #@family_dishes = FamilyDish.includes(:family_dish_ingredients).includes(:ingredients).where(family_id: params[:family_id])
      #@family_dishes = FamilyDish.includes(:family_dish_ingredients).where(family_id: params[:family_id])
    else
      @family_dishes = FamilyDish.includes(:ingredients).all
      #@family_dishes = FamilyDish.includes(:family_dish_ingredients).all
      #@family_dishes = FamilyDish.eager_load(:ingredients).all
      #@family_dishes = FamilyDish.eager_load(:family_dish_ingredients).eager_load(:ingredients).all
    end
    #@family_dishes.each { |dish|
      #dish.family_dish_ingredients.each { |fdi| 
      #  fdi.ingredient = dish.ingredients.select { |ingredient| fdi.ingredient_id == ingredient.id }.first
      #  logger.debug "Ingredient: #{fdi.ingredient.to_json}"
      #}
    #  dish["my_ingredients"] = dish.ingredients.map { |ingredient| Ingredient.new(ingredient.to_h.merge(dish.family_dish_ingredients.select { |fdi| fdi.ingredient_id == ingredient.id }.first.to_h)) }
      #dish.ingredients.each { |ingredient|
      #  ingredient.merge(dish.family_dish_ingredients.select { |fdi| fdi.ingredient_id == ingredient.id }.first)

        #ingredient.ingredient_id = ingredient.id
        #family_dish_ingredient = dish.family_dish_ingredients.select { |fdi| fdi.ingredient_id == ingredient.ingredient_id }.first
        #ingredient.id = family_dish_ingredient.id
        #ingredient.relationship = family_dish_ingredient.relationship
      #}
    #}
    respond_to do |format|
      format.html
      #format.json { render :json => @family_dishes  }
      #format.json { render :json => @family_dishes.to_json( include: [{:family_dish_ingredients => {:include => [:ingredient]}}] ) }
      #format.json { render :json => @family_dishes.to_json( include: {family_dish_ingredients: {include: [:ingredient]}} ) }
      format.json { render :json => @family_dishes, include: {family_dish_ingredients: {include: [:ingredient]}} }
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
      params.require(:family_dish).permit(:parent_id,:family_id,:name,:description,:is_favorite,:comfort_level,:health_level,:cooking_difficulty,:is_prepared_ahead,:prep_time_minutes,:cooking_time_minutes,:serving_size,:protein_grams,:calories,
      family_dish_ingredients_attributes: [:id, :ingredient_id, :relationship],
      ingredients: [:id, :name, :parent_id, :family_id, :is_basic, :is_public, :serving_size, :calories, :protein_grams, :vegetarian, :vegan, :gluten_free, :_destroy])

    end
end
