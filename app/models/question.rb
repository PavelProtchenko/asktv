class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  validates :text, :user, presence: true
  validates :text, length: {maximum: 255}
  has_many :hashtags

  after_commit :create_hashtags

  private

    def create_hashtags
      question_hashtags = []
      
      regexp = /(?<=#)[a-z_а-я0-9\-]+/i

      unless text.blank?
        question_hashtags += text.scan(regexp)
      end
  
      unless answer.blank?
        question_hashtags += answer.scan(regexp)
      end

      question_hashtags.uniq!

      question_hashtags.each do |item|
        hashtags.build(title: item.to_s).save()
      end
    end
end
