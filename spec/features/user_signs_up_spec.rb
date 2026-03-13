require 'rails_helper'

RSpec.feature "User signs up", type: :feature do
  scenario "with valid email and password" do
    visit new_user_registration_path
    fill_in "Email", with: "testuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"

    expect(page).to have_content("Welcome! You have signed up successfully")
    expect(User.last.email).to eq("testuser@example.com")
  end

  scenario "with invalid email" do
    visit new_user_registration_path
    fill_in "Email", with: "invalid"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"

    expect(page).to have_content("Email is invalid")
  end
end
