require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:follower).class_name("User") }
    it { should belong_to(:followed).class_name("User") }
  end

  describe "validations" do
    it { should validate_presence_of(:follower_id) }

    subject { create(:follow) }
    it { should validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }
  end

   describe "enum" do
    it { should define_enum_for(:status).with_values(pending: 0, accepted: 1) }
  end
end
