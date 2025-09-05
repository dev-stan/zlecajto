# frozen_string_literal: true

class Tasks::SubmissionFrameComponent < ApplicationComponent
  def initialize(submission:, accepted: false)
    super()
    @submission = submission
    @accepted = accepted
  end

  private

  attr_reader :submission, :accepted
end
