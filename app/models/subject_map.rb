class SubjectMap < ApplicationRecord
  belongs_to :subject, optional: true
  belongs_to :school

  def self.from_wonde(school, subject_data)
    subject_data.each do |client_subject|
      create_subject_map(client_subject, school)
    end
  end

  def self.create_subject_map(client_subject, school)
    subject_map = where(client_id: client_subject.id).first_or_initialize
    subject_map.school = school
    subject_map.client_subject_name = client_subject.name
    # Check to see if this subject is in the default
    # subject map table
    default_subject = DefaultSubjectMap.where(name: subject_map.client_subject_name).first
    subject_map.subject = default_subject.subject if default_subject.present?
    subject_map.save
  end

  def self.subjects_for_school(school)
    SubjectMap.where.not(subject_id: nil).where(school_id: school)
  end
end
