# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @accordion_elements = [['Opisz z czym potrzebujesz pomocy', '1'], ['Zdefiniuj cenę usługi', '2'],
                           ['Otrzymaj oferty i wybierz tą która tobie odpowiada', '3']]

    @faq_items = [
      { title: 'Jak zlecić zadanie?',
        content: 'Kliknij przycisk "Zleć zadanie", wypełnij krótki formularz i poczekaj na oferty wykonawców.' },
      { title: 'Dlaczego warto wybrać ZlecajTo.pl?',
        content: 'Łatwo porównujesz oferty, oszczędzasz czas i masz dostęp do lokalnych, zweryfikowanych wykonawców.' },
      { title: 'Czy ZlecajTo.pl coś kosztuje?',
        content: 'Rejestracja jest darmowa. Płacisz jedynie za zrealizowane zlecenia według uzgodnionej ceny.' },
      { title: 'Jak zostać wykonawcą?',
        content: 'Załóż konto wykonawcy, uzupełnij profil i zacznij odpowiadać na dostępne ogłoszenia w swojej okolicy.' }
    ]
  end

  def profile
    @user = current_user
    @tasks = current_user.tasks.includes(:submissions).order(created_at: :desc)
    @submissions = current_user.submissions.includes(task: :user).order(created_at: :desc)
    return unless params[:tab] == 'submissions' && @submissions.accepted.exists?

    current_user.mark_accepted_submissions_seen!
  end

  def tos; end

  def privacy; end

  def waitlist; end
end
