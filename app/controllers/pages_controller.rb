# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @accordion_elements = [['Opisz z czym potrzebujesz pomocy', '1'], ['Zdefiniuj cenę usługi', '2'],
                           ['Otrzymaj oferty i wybierz tą która tobie odpowiada', '3']]
  end
end
