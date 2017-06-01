module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def declansion(number, krokodil, krokodila, krokodilov)
    if number % 100 >= 5 && number % 100 <= 20
      krokodilov

    elsif number % 10 == 1
      krokodil

    elsif number % 10 >= 2 && number % 10 <= 4
      krokodila

    else
      krokodilov
    end
  end
end
