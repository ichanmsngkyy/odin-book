# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Post.destroy_all
User.destroy_all

# Create users
user1 = User.create!(
  email: "alice@example.com",
  password: "password123",
  password_confirmation: "password123"
)

user2 = User.create!(
  email: "bob@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Create posts
user1.posts.create!(content: "Hello world! This is my first post.")
user1.posts.create!(content: "Loving this Twitter clone!")

user2.posts.create!(content: "Just joined! Excited to be here.")
user2.posts.create!(content: "What a beautiful day!")

puts "Created #{User.count} users and #{Post.count} posts"
