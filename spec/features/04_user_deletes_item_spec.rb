require "spec_helper"

feature "user deletes item" do
  scenario "successfully deletes grocery item" do
    visit "/groceries"
    fill_in "Name", with: "Walnuts"
    click_button "Submit"
    expect(page).to have_content "Walnuts"

    click_button "Delete"
    expect(page).to have_no_content "Walnuts"
  end
end
