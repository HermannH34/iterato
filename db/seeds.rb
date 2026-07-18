if Rails.env.local?
  User.find_or_create_by!(email_address: "admin@iterato.agency") do |u|
    u.password = "changeme"
  end
end
