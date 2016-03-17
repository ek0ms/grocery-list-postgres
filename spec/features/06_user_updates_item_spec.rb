require "spec_helper"

feature "user edits item" do
  scenario "successfully updates item" do
    visit "/groceries"
    fill_in "Name", with: "Alfredo Sauce"
    click_button "Submit"
    expect(page).to have_content "Alfredo Sauce"

    click_button "Update"
    expect(page).to have_content "Edit Your Item Below"

    fill_in "Name", with: "Tomato Sauce"
    click_button "Submit"
    expect(page).to have_content "Tomato Sauce"
  end

  scenario "submit form without name" do
    visit "/groceries"
    fill_in "Name", with: "Alfredo Sauce"
    click_button "Submit"
    expect(page).to have_content "Alfredo Sauce"

    click_button "Update"
    expect(page).to have_content "Edit Your Item Below"

    fill_in "Name", with: ""
    click_button "Submit"
    expect(page).to have_content "Edit Your Item Below"
  end
end
