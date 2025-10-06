# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @accordion_elements = [['Opisz z czym potrzebujesz pomocy', '1'], ['Zdefiniuj cenę usługi', '2'],
                           ['Otrzymaj oferty i wybierz tą która tobie odpowiada', '3']]

    @faq_items = [
      { title: 'Czy ZlecajTo.pl coś kosztuje?',
        content: 'Rejestracja jest darmowa. Płacisz jedynie za zrealizowane zlecenia według uzgodnionej ceny.' },
      { title: 'Czy mogę zlecać i wykonywać?',
        content: 'Tak, u nas jest możesz zlecać i wykonywać - wszystko na jednej platformie.' },
      { title: 'Co można zlecać?',
        content: 'Możesz zlecać dosłownie wszystko, korki, sprzątanie, przeprowadzki czy porządkowanie kabli, które rosły od 2003 roku.' },
      { title: 'Coś poszło nie tak, co teraz?',
        content: 'Zadzwoń do nas ( 881 228 832 ) lub napisz do nas maila ( admin@zlecajto.pl ), spróbujemy rozwiązać problem jak najszybciej.' }
    ]

    @categories = Task::CATEGORIES_HOME
  end

  def profile
    @user = current_user
    @tasks = current_user.tasks.includes(:submissions).order(created_at: :desc)
    @submissions = current_user.submissions.includes(task: :user).order(created_at: :desc)
    return unless params[:tab] == 'submissions' && @submissions.accepted.exists?

    current_user.mark_accepted_submissions_seen!
  end

  def categories; end

  def tos; end

  def privacy; end

  def waitlist; end

  def contact; end
end
