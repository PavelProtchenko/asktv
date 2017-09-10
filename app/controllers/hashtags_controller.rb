class HashtagsController < ApplicationController
  def show
    @title = params[:id]
    hashtags = Hashtag.where(title: params[:id])

    @questions = []

    hashtags.each do |hashtag|
     @questions << hashtag.question
    end
  end
end
