require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase

  # def setup
  #   visit '/'

  #   click_on 'Login'

  #   fill_in("username-login", with: "palpatine")
  #   fill_in("password-signup", with: "secretive")
  #   click_on "Log in"
  # end

  # test "rich wiki editor functions correctly" do
  #   visit "/wiki/wiki-page-path"
  #   find("a[data-original-title='Try the beta inline Rich Wiki editor.'").click()
  #   first("div.inline-section").hover()

  #   using_wait_time(4) { first("a.inline-edit-btn").click() }

  #   find("div.wk-wysiwyg").set("wiki text")

  #   click_on "Save"
  #   page.assert_selector("p", text: "wiki text")
  # end

  # test "markdown wiki editor functions correctly" do
  #   visit "/wiki/wiki-page-path"
  #   find("a[data-original-title='Edit this wiki page.'").click()

  #   find("#text-input").native.send_keys("wiki text")
  #   find("a#publish").click()

  #   page.assert_selector("p", text: "wiki text")
  # end

  # test "different rich wiki editor features" do
  #   visit "/wiki/wiki-page-path"
  #   find("a[data-original-title='Try the beta inline Rich Wiki editor.'").click()
  #   first("div.inline-section").hover()

  #   using_wait_time(4) { first("a.inline-edit-btn").click() }

  #   # test the following features
  #   ["bold", "italic", "code", "heading"].each do |element|
  #     find("button.woofmark-command-#{element}").click()
  #     find("div.wk-wysiwyg").native.send_key(:arrow_left, :enter)
  #   end

  #   click_on "Save"

  #   # assert that the features have worked and that the correct wiki elements are displayed
  #   page.assert_selector("strong", text: "strong text")
  #   page.assert_selector("h1", text: "Heading Text")
  #   page.assert_selector("em", text: "emphasized text")
  #   page.assert_selector("code", text: "code goes here")
  # end

  # test "different markdown wiki editor features" do
  #   visit "/wiki/wiki-page-path"
  #   find("a[data-original-title='Edit this wiki page.']").click()

  #   # test the following features
  #   ["**strong text**", "_emphasized text_", "`code goes here`", "# Heading Text"].each do |element|
  #     find("#text-input").native.send_keys(element)
  #     find("#text-input").native.send_keys(:enter)
  #   end

  #   find("a#publish").click()

  #   # assert that the features have worked and that the correct wiki elements are displayed
  #   page.assert_selector("strong", text: "strong text")
  #   page.assert_selector("h1", text: "Heading Text")
  #   page.assert_selector("em", text: "emphasized text")
  #   page.assert_selector("code", text: "code goes here")
  # end

  #test "das" do
  #  visit "/login"
  #  fill_in("username-login", with: "paaaalpatine")
  #  fill_in("password-signup", with: "secretive")
  #  click_on "Log in"
  #  sleep(20)
 # end
  # test "dsda" do
  #   visit "/"
  #   OmniAuth.config.mock_auth[:facebook2]
  #   visit "/post"
  # end

  test "changing and reverting versions works correctly for wiki" do
    wiki = nodes(:wiki_page)
    visit '/'
    click_on 'Login'

    fill_in("username-login", with: "jeff")
    fill_in("password-signup", with: "secretive")
    click_on "Log in"

    visit wiki.path
    # save text of wiki before edit
    old_wiki_content = find("#content").text

    # edit content
    find("a[data-original-title='Try the beta inline Rich Wiki editor.']").click()
    first("div.inline-section").hover()
    using_wait_time(2) { first("a.inline-edit-btn").click() }
    find("div.wk-wysiwyg").set("wiki text")
    click_on "Save"

    # view wiki
    find("a[href='#{wiki.path}'").click()
    current_wiki_content = find("#content").text
    # make sure edits worked and text is different
    assert current_wiki_content != old_wiki_content

    find("a[data-original-title='View previous versions of this page.']").click()
    accept_confirm "Are you sure?" do
      # revert to previous version of wiki
      all("a", text: "Revert")[1].click()
    end
    visit wiki.path
    
    # check old wiki content is the same as current content after revert
    assert old_wiki_content == find("#content").text 
  end

  test "revision diff is displayed when comparing versions" do
    wiki = nodes(:wiki_page)
    visit '/'
    click_on 'Login'

    fill_in("username-login", with: "palpatine")
    fill_in("password-signup", with: "secretive")
    click_on "Log in"

    visit wiki.path

    # edit content
    find("a[data-original-title='Try the beta inline Rich Wiki editor.']").click()
    first("div.inline-section").hover()
    using_wait_time(2) { first("a.inline-edit-btn").click() }
    find("div.wk-wysiwyg").native.send_keys(:enter, "wiki text")
    click_on "Save"

    find("a[href='#{wiki.path}'").click()
    find("a[data-original-title='View previous versions of this page.']").click()


    # verify additions are displayed as green `<ins>` tags
    page.assert_selector("ins", text: "<p>wiki")
    page.assert_selector("ins", text: "text</p>")
  end
end
