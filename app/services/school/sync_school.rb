require 'wondeclient'
class School::SyncSchool
  def initialize(school)
    @school = school
    @client = Wonde::Client.new(school.token)
    @school_from_client = @client.schools.get(school.client_id)
    @data_from_client = @client.school(school.client_id)
  end

  def call
    return if @school.sync_status == 'syncing'

    School.from_wonde_sync_start(@school)
    fetch_api_data
    sync_all_data
    School.from_wonde_sync_end(@school)
  end

  def fetch_api_data
    # To limit API calls and improve performance - get all classroom and student data here
    @subject_data = @data_from_client.subjects.all
    @sync_data = @data_from_client.classes.all(%w[subject students employees])
    @deletion_data = @data_from_client.deletions.all
  end

  def sync_all_data
    SubjectMap.from_wonde(@school, @subject_data)
    Classroom.from_wonde(@school, @sync_data)
    User.from_wonde(@school, @sync_data)
    Enrollment.from_wonde(@school, @sync_data)
  end
end