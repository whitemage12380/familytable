require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ingredient = ingredients(:one)
  end

  test "should get index" do
    get ingredients_url
    assert_response :success
  end

  test "should get new" do
    get new_ingredient_url
    assert_response :success
  end

  test "should create ingredient" do
    assert_difference('Ingredient.count') do
      post ingredients_url, params: { ingredient: { calories: @ingredient.calories, is_basic: @ingredient.is_basic, is_public: @ingredient.is_public, name: @ingredient.name, parent_id: @ingredient.parent_id, protein_grams: @ingredient.protein_grams, serving_size: @ingredient.serving_size } }
    end

    assert_redirected_to ingredient_url(Ingredient.last)
  end

  test "should show ingredient" do
    get ingredient_url(@ingredient)
    assert_response :success
  end

  test "should get edit" do
    get edit_ingredient_url(@ingredient)
    assert_response :success
  end

  test "should update ingredient" do
    patch ingredient_url(@ingredient), params: { ingredient: { calories: @ingredient.calories, is_basic: @ingredient.is_basic, is_public: @ingredient.is_public, name: @ingredient.name, parent_id: @ingredient.parent_id, protein_grams: @ingredient.protein_grams, serving_size: @ingredient.serving_size } }
    assert_redirected_to ingredient_url(@ingredient)
  end

  test "should destroy ingredient" do
    assert_difference('Ingredient.count', -1) do
      delete ingredient_url(@ingredient)
    end

    assert_redirected_to ingredients_url
  end
end
