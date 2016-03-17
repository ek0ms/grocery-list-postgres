require "spec_helper"

feature "user goes to edit page" do
  scenario "successfully goes to grocery edit page" do
    visit "/groceries"
    fill_in "Name", with: "Alfredo Sauce"
    click_button "Submit"
    expect(page).to have_content "Alfredo Sauce"

    click_button "Update"
    expect(page).to have_content "Edit Your Item Below"
  end
end
