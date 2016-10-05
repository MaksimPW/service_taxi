require 'rails_helper'

RSpec.feature 'User sign in' do
  let(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path

    click_button 'Log in'

    expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: 'Email')
    expect(current_path).to eq new_user_session_path
  end
end