require "application_system_test_case"

class EditorTest < ApplicationSystemTestCase

  def setup
    visit '/'

    click_on 'Login'

    fill_in("username-login", with: "palpatine")
    fill_in("password-signup", with: "secretive")
    click_on "Log in"
  end

  test "rich wiki editor functions correctly" do
    visit "/wiki/wiki-page-path"
    find("a[data-original-title='Try the beta inline Rich Wiki editor.'").click()
    first("div.inline-section").hover()

    # click edit btn
    using_wait_time(2) { first("a.inline-edit-btn").click() }

    find("div.wk-wysiwyg").set("wiki text")

    click_on "Save"
    page.assert_selector("p", text: "wiki text")
  end

  test "markdown wiki editor functions correctly" do
    visit "/wiki/wiki-page-path"
    find("a[data-original-title='Edit this wiki page.'").click()

    find("#text-input").set("wiki text")
    find("a#publish").click()

    page.assert_selector("p", text: "wiki text")
  end

  test "different rich wiki editor features" do
    visit "/wiki/wiki-page-path"
    find("a[data-original-title='Try the beta inline Rich Wiki editor.'").click()
    first("div.inline-section").hover()

    using_wait_time(2) { first("a.inline-edit-btn").click() }

    # test the following features
    ["bold", "italic", "code", "heading"].each do |element|
      # clicking on the button generates the element with dummy text
      find("button.woofmark-command-#{element}").click()
      # these keys are called to deselect the previous elements
      find("div.wk-wysiwyg").native.send_key(:arrow_left, :enter)
    end

    click_on "Save"

    # assert that the features have worked and that the correct wiki elements are displayed
    page.assert_selector("strong", text: "strong text")
    page.assert_selector("h1", text: "Heading Text")
    page.assert_selector("em", text: "emphasized text")
    page.assert_selector("code", text: "code goes here")
  end

  test "different markdown wiki editor features" do
    visit "/wiki/wiki-page-path"
    find("a[data-original-title='Edit this wiki page.']").click()

    # test the following features
    ["**strong text**", "_emphasized text_", "`code goes here`", "# Heading Text"].each do |element|
      find("#text-input").native.send_keys(element)
      find("#text-input").native.send_keys(:enter)
    end

    find("a#publish").click()

    # assert that the features have worked and that the correct wiki elements are displayed
    page.assert_selector("strong", text: "strong text")
    page.assert_selector("h1", text: "Heading Text")
    page.assert_selector("em", text: "emphasized text")
    page.assert_selector("code", text: "code goes here")
  end
end
