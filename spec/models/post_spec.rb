require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "associations" do
    it { should belong_to (:user) }
    it { should have_many(:likes) }

    it { should have_many(:comments) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(240) }
  end
end
