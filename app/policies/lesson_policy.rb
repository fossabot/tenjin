# frozen_string_literal: true

class LessonPolicy < ApplicationPolicy
  attr_reader :user, :record

  class Scope < Scope
    def resolve
      scope.joins(:topic)
           .where(topics: { subject_id: user.subjects })
    end
  end

  def new?
    user.has_role? :lesson_author, record.subject
  end

  alias create? new?
  alias edit? new?
  alias update? new?
  alias destroy? new?
end
