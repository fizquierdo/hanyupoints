require 'test_helper'

class WordsControllerTest < ActionController::TestCase
	include Devise::TestHelpers
  setup do
    @word = words(:one)
		sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not create word if word exists" do
    assert_no_difference('Word.count') do
			existing_word = { han: @word.han, meaning: @word.meaning, pinyin: @word.pinyin, pinyin_num: @word.pinyin}
      post :create, word: existing_word
    end

  end

  test "should create word if hanzi is new" do
    assert_difference('Word.count') do
			wo = { han: '她', pinyin: 'ta1', pinyin_num: 'ta1'}
      post :create, word: wo
    end
    assert_redirected_to word_path(assigns(:word))
  end

  test "should show word" do
    get :show, id: @word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @word
    assert_response :success
  end

  test "should update word" do
    patch :update, id: @word, word: { han: @word.han, meaning: @word.meaning, pinyin: @word.pinyin }
    assert_redirected_to word_path(assigns(:word))
  end

  test "should destroy word" do
    assert_difference('Word.count', -1) do
      delete :destroy, id: @word
    end

    assert_redirected_to words_path
  end
end
