require "application_system_test_case"
# https://guides.rubyonrails.org/testing.html#implementing-a-system-test

class PostTest < ApplicationSystemTestCase
  Capybara.default_max_wait_time = 60

  # test 'posting from the editor' do
  #   visit '/'

  #   click_on 'Login'
  #   fill_in("username-login", with: "Bob")
  #   fill_in("password-signup", with: "secretive")
  #   click_on "Log in"

  #   visit '/post'

  #   fill_in("title-input", with: "My new post")
    
  #   el = find(".wk-wysiwyg") # rich text input
  #   el.set("All about this interesting stuff")

  #   assert_page_reloads do

  #     find('.ple-publish').click
  #     assert_selector('h1', text: "My new post")
  #     assert_selector('#content', text: "All about this interesting stuff")
  #     assert_selector('.alert-success', text: "×\nSuccess! Thank you for contributing open research, and thanks for your patience while your post is approved by community moderators and we'll email you when it is published. In the meantime, if you have more to contribute, feel free to do so.")
      
  #   end

  # end

  test "follow author of post from tooltip" do
    visit '/'

    click_on 'Login'
    fill_in("username-login", with: "palpatine")
    fill_in("password-signup", with: "secretive")
    click_on "Log in"

    post = nodes(:post_test1)
    visit post.path

    find("span[data-original-title='Tools'").click()
    find("li[title='Follow by tag or author']").click()
    find("a[href='/relationships?follower_id=#{post.author.id}']").click()

    page.assert_selector("div.alert", text: "You have started following #{post.author}")
end
  test "spam note" do
    visit '/'

    click_on 'Login'
    fill_in("username-login", with: "palpatine")
    fill_in("password-signup", with: "secretive")
    click_on "Log in"

    post = nodes(:post_test1)
    visit post.path
    find("span[data-original-title='Tools'").click()
    find("a[href='/moderate/spam/#{post.id}'").click()

    page.assert_selector("div.alert-success", text:"Item marked as spam and author banned. You can undo this on the spam moderation page")

    visit post.path
    page.assert_selector("span", text: "UNPUBLISHED")
  end


  #test "location modal with coordinates"
  # Utility methods:
  
  # def assert_page_reloads(message = "page should reload")
  #   page.evaluate_script "document.body.classList.add('not-reloaded')"
  #   yield
  #   if has_selector? "body.not-reloaded"
  #     assert false, message
  #   end
  # end

  # def assert_page_does_not_reload(message = "page should not reload")
  #   page.evaluate_script "document.body.classList.add('not-reloaded')"
  #   yield
  #   unless has_selector? "body.not-reloaded"
  #     assert false, message
  #   end
  #   page.evaluate_script "document.body.classList.remove('not-reloaded')"
  # end
end

