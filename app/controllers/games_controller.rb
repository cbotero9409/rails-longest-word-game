require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @string = (0...10).map { (65 + rand(26)).chr }
  end

  def find_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json = URI.open(url).read
    hash = JSON.parse(json)
    hash['found']
  end

  def comparation(word, string)
    word.chars.each do |letter|
      return false unless string.include? letter

      string.delete(letter)
    end
    true
  end

  def get_score(word, time)
    length = word.length / 10.0
    time_subs = Time.new - time.to_time
    (length * 1_000_000) / time_subs
  end

  def score
    return unless params[:authenticity_token]

    word = params[:word].upcase
    @score = "Sorry but #{word} can't be built out of #{params[:string]}"
    return unless comparation(word, params[:string])

    @score = "Sorry but #{word} does not seem to be a valid English word..."
    return unless find_word(word)

    @score = "Congratulations: #{get_score(word, params[:time])}"
  end
end
