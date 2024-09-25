require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      tenant = build(:tenant)
      expect(tenant).to be_valid
    end

    it 'is invalid without a database_name' do
      tenant = build(:tenant, database_name: nil)
      expect(tenant).not_to be_valid
      expect(tenant.errors[:database_name]).to include("can't be blank")
    end

    it 'is invalid without a database_username' do
      tenant = build(:tenant, database_username: nil)
      expect(tenant).not_to be_valid
      expect(tenant.errors[:database_username]).to include("can't be blank")
    end

    it 'is invalid without a domain_name' do
      tenant = build(:tenant, domain_name: nil)
      expect(tenant).not_to be_valid
      expect(tenant.errors[:domain_name]).to include("can't be blank")
    end

    it 'is invalid without a name' do
      tenant = build(:tenant, name: nil)
      expect(tenant).not_to be_valid
      expect(tenant.errors[:name]).to include("can't be blank")
    end
  end
end
