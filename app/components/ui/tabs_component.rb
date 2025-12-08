# frozen_string_literal: true

class Ui::TabsComponent < ApplicationComponent
  renders_many :tabs, "Tab"

  def initialize(default_tab:)
    @default_tab = default_tab
  end

  class Tab < ApplicationComponent
    attr_reader :id, :label, :count

    def initialize(id:, label:, count: nil)
      @id = id
      @label = label
      @count = count
    end

    def call
      content
    end
  end
end
