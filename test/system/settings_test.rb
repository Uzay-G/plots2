require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  Capybara.default_max_wait_time = 60

  def setup

  end


  test "update password" do
    visit '/profile/edit'
    fill_in("#password1", with: "password")
    fill_in("#current_password", with: "secretive")
    fill_in("#password-confirmation", with: "password")
  end

  test "edit profile settings and upload image" do
    visit "/profile/edit"
    # fill_in("username", with: "my_username")
    # fill_in("user_bio", with: "An amazing bio!")

    fileinput_element = page.all('#profile-fileinput')

    # Upload the image
    fileinput_element.set("#{Rails.root.to_s}/public/images/pl.png")

    # Wait for image upload to finish
    wait_for_ajax
  end
end

