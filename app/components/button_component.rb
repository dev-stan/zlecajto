class ButtonComponent < ViewComponent::Base
  # Renders a styled button.
  # Modes:
  #  - submit: true => <button type="submit">
  #  - button: true => <button type="button">
  #  - default (link) => <a href="path">
  def initialize(text:, path: nil, submit: false, button: false)
    @text = text
    @path = path
    @submit = submit
    @button = button
  end

  def submit?; !!@submit; end
  def button?; !!@button; end
end
