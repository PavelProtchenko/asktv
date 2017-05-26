class UsersController < ApplicationController
  def index
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Vadim',
      username: 'installero',
      avatar_url: 'https://secure.gravatar.com/avatar/7126968e0f757ddb4f73614f43ae445?s=100'
    )

    @questions = [
        Question.new(text: 'Как жизнь?', created_at: Date.parse('26.05.2017')),
        Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('26.05.2017'))
    ]
  end
end
