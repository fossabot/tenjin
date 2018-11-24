require 'rails_helper'
require 'support/api_data'

RSpec.describe Enrollment, type: :model do
  let(:school) {create(:school, client_id: '1234')}
  let(:subject_map) {create(:subject_map, school: school)}

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:classroom) }
  context 'with classroom and user data ' do
    let(:school) { create(:school) }
    let(:classrooms) { create_list(:classroom, 2, school: school, subject: subject_map.subject) }
    let(:student) { create(:student, school: school) }

    before do
      create(:enrollment, classroom: classrooms[0], user: student)
    end

    it 'allows multiple classroom per user' do
      expect { create(:enrollment, classroom: classrooms[1], user: student) }.not_to raise_error
    end

    it 'validates uniqueness of user scoped to classroom' do
      expect { create(:enrollment, classroom: classrooms[0], user: student) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#from_wonde' do
    include_context 'api_data'
    before do
      create(:classroom, client_id: 'classroom_id', school: school, subject: subject_map.subject)
      create(:student, upi: '01234')
      classroom_api_data[0].id = 'classroom_id'
    end

    context 'with api data' do
      it 'creates student enrollments' do
        classroom_api_data[0].students = user_api_data
        Enrollment.from_wonde(school_api_data, classroom_api_data)
        expect(Enrollment.count).to eq(1)
      end

      it 'creates employee enrollments' do
        classroom_api_data[0].employees = user_api_data
        Enrollment.from_wonde(school_api_data, classroom_api_data)
        expect(Enrollment.count).to eq(1)
      end

      it 'removes older enrollments that are no longer present' do
        classroom_api_data[0].students = user_api_data
        Enrollment.from_wonde(school_api_data, classroom_api_data)
        classroom_api_data[0].students = alt_user_api_data
        Enrollment.from_wonde(school_api_data, classroom_api_data)
        expect(Enrollment.count).to eq(0)
      end

      it 'handles null student and employee data' do
        Enrollment.from_wonde(school_api_data, classroom_api_data)
        expect(Enrollment.count).to eq(0)
      end
    end
  end
end