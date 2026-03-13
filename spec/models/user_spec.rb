require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  describe "associations" do
    it { should have_many(:posts) }

    it { should have_many(:active_follows) }
    it { should have_many(:passive_follows) }

    it { should have_many(:followers) }

    it { should have_many(:following) }

    it { should have_many(:likes) }

    it { should have_many(:comments) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }

    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a short password" do
      user = build(:user, password: "123")
      expect(user).not_to be_valid
    end
  end

  describe "callbacks" do
   it "is sending email after creation" do
      expect(UserMailer).to receive(:welcome_email) do |user_arg|
        expect(user_arg.email).to eq("test1@gmail.com")
        double(deliver_later: true)
      end
    create(:user, email: "test1@gmail.com", password: "password123")
    end
  end

  describe "omniauth" do
    it "is expected to create user from auth hash" do
    auth = OmniAuth::AuthHash.new(
      provider: "github",
      uid: "12345",
      info: { email: "test@gmail.com", image: "http://example.com/avatar.png" }
    )
    user = User.from_omniauth(auth)
    expect(user.email).to eq("test@gmail.com")
    expect(user.avatar_url).to eq("http://example.com/avatar.png")
    end
  end

  describe "#profile_picture" do
    it "is expected to return avatar_url if present" do
    user.avatar_url = "http://example.com/avatar.png"
    expect(user.profile_picture).to eq("http://example.com/avatar.png")
    end

    it "is expected to use gravatar if profile is nil " do
    user = build(:user, email: "test@gmail.com", avatar_url: nil)
    hash = Digest::MD5.hexdigest("test@gmail.com".downcase.strip)
    expect(user.profile_picture).to eq("https://www.gravatar.com/avatar/#{hash}?d=identicon&s=#{200}")
    end

    it "is expected to returns gravatar url with custom size" do
       user = build(:user, email: "test@gmail.com", avatar_url: nil)
      hash = Digest::MD5.hexdigest("test@gmail.com".downcase.strip)
      expect(user.profile_picture(size: 500)).to eq("https://www.gravatar.com/avatar/#{hash}?d=identicon&s=500")
    end
  end
end
