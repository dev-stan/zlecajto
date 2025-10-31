# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    console
    @accordion_elements = [['Opisz z czym potrzebujesz pomocy', '1'], ['Zdefiniuj cenę usługi', '2'],
                           ['Otrzymaj oferty i wybierz tą która tobie odpowiada', '3']]

    @faq_items = [
      { title: 'Czy ZlecajTo.pl coś kosztuje?',
        content: 'Rejestracja jest darmowa. Płacisz jedynie za zrealizowane zlecenia według uzgodnionej ceny.' },
      { title: 'Czy mogę zlecać i wykonywać?',
        content: 'Tak, u nas możesz zlecać i wykonywać - wszystko na jednej platformie.' },
      { title: 'Co można zlecać?',
        content: 'Możesz zlecać dosłownie wszystko, korki, sprzątanie, przeprowadzki czy porządkowanie kabli, które rosły od 2003 roku.' },
      { title: 'Coś poszło nie tak, co teraz?',
        content: 'Zadzwoń do nas ( 881 228 832 ) lub napisz do nas maila ( admin@zlecajto.pl ), spróbujemy rozwiązać problem jak najszybciej.' }
    ]
    @user = current_user
  end

  def categories; end

  def tos; end

  def privacy; end

  def contact; end
end
