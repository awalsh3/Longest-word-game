require 'open-URI'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @attempt = params[:word]
    @letters = params[:letters]

    if !letter_in_grid
      @result = "Sorry, but #{@attempt.upcase} can’t be built out of grid letters."
    elsif !english_word
      @result = "Sorry but #{@attempt.upcase} does not seem to be an English word."
    elsif letter_in_grid && !english_word
      @result = "Sorry but #{@attempt.upcase} does not seem to be an English word."
    else letter_in_grid && !english_word
      @result = "Congratulations! #{@attempt.upcase} is a valid English word."
    end
  end

  private

  def english_word
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def letter_in_grid
    word_chars = @attempt.downcase.chars
    letters_chars = @letters.downcase.split

    word_chars.all? do |char|
      word_chars.count(char) <= letters_chars.count(char)
    end
  end
end
