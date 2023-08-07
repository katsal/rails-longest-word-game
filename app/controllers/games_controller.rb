require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    cookies[:grand_total] = {
      value: 0
    }
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    #1.check if word is valid using api
    #2.check if word size is leq 10
    #3.then check if word is using only grid
    @word = params[:word]
    @original_grid = params[:letters]
    @valid_word = valid_word?(@word)
    @from_original = from_original?(@original_grid.split, @word)
    @score = @word.length * 10 if @valid_word && @from_original
    cookies[:grand_total] = cookies[:grand_total].to_i + @score
  end

  private

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

  def from_original?(letters, word)
    word.chars.all? do |char|
      letters.include?(char.upcase)
    end
  end
end
