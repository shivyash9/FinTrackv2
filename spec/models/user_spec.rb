require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is invalid with a duplicate email' do
      FactoryBot.create(:user, email: 'test@example.com')
      user.email = 'test@example.com'
      expect(user).to_not be_valid
    end

    it 'is invalid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:user_budgets).dependent(:destroy) }
    it { is_expected.to have_many(:expenses).dependent(:destroy) }
  end


  describe '#admin?' do
    it 'returns true if the user is an admin' do
      user.is_admin = true
      expect(user.admin?).to be true
    end

    it 'returns false if the user is not an admin' do
      user.is_admin = false
      expect(user.admin?).to be false
    end
  end

  describe 'default values' do
    it 'is not an admin by default' do
      expect(user.is_admin).to be false
    end

    it 'is not blocked by default' do
      expect(user.is_blocked).to be false
    end
  end
end
