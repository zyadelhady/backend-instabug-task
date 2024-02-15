# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
i=1
5.times do
  Application.create({name: "AppLication " + i.to_s, token: SecureRandom.uuid})
  j=1
  5.times do
    Chat.create({application_id: Application.last.id, number:j})
    j=j+1
    k = 1
    5.times do
      Message.create({chat_id:Chat.last.id,number:k,
      content:"Message " + k.to_s})
      k = k + 1
    end
  end
  i=i+1
end
