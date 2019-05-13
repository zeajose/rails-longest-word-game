require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].strip
    @score = @word.length
    @letters = params[:letters]

    word_exist = api(@word)['found']
    word_in_grid = grid_check(@word, @letters)
    @decision = results(word_exist, word_in_grid)
  end

  def api(word)
    api_url = 'https://wagon-dictionary.herokuapp.com'
    word_url = "#{api_url}/#{word}"
    word_serialized = open(word_url).read
    word_hash = JSON.parse(word_serialized)
    word_hash
  end

  def grid_check(word, letters)
    word.chars.all? { |c| word.upcase.chars.count(c) <= letters.chars.count(c) }
  end

  def results(word_exist, word_in_grid)
    if word_in_grid == false
      @decision = "SORRY but the word #{@word.upcase} can't be built out of the original grid: #{@letters}"
    elsif word_in_grid == true && word_exist == false
      @decision = "The word #{@word.upcase} is valid according to the grid, but is not English."
    elsif word_in_grid == true && word_exist == true
      @decision = "CONGRATS! #{@word.upcase} is valid according to the grid and is an English word. SCORE: +#{@score} points"
    else
      @decision = "#{@word.upcase} is unknown to this grid: #{@letters}"
    end
  end
end
