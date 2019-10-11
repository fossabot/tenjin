require 'rails_helper'
require 'support/api_data'

RSpec.describe School, type: :model do
  include_context 'api_data'
  subject { create(:school) }

  it { is_expected.to validate_presence_of(:client_id) }
  it { is_expected.to validate_uniqueness_of(:client_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:token) }

  describe '#from_wonde' do
    let(:school) { School.from_wonde(OpenStruct.new(id: '1234', name: 'test'), 'token') }

    it 'Adds a school from a wonde object' do
      expect(school.persisted?).to be true
    end

    it 'Updates a school from a wonde object' do
      create(:school, id: '1234', name: 'old name')
      school
      expect(school).to have_attributes(client_id: '1234', name: 'test')
    end
  end
end
