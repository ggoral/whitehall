When(/^I start drafting a news article$/) do
  begin_drafting_news_article title: 'News Article'
end

When(/^I add an attachment$/) do
  click_on "Save and add attachment"
  fill_in "Title", with: 'An attachment title'
  attach_file "File", Rails.root.join("features/fixtures", "attachment.pdf")
  click_on "Save"

  @attachment = Attachment.last
end

Then(/^I should see the attachment listed on the form with it's markdown code$/) do
  within record_css_selector(@attachment) do
    assert_equal @attachment.title, find_field('Title').value
    assert_equal '!@1', find_field('markdown').value
    assert_equal '[InlineAttachment:1]', find_field('markdown_inline').value
  end
end

When(/^I save the news article$/) do
  click_on "Save"
end

Then(/^I should see the attachment listed on the attachments tab$/) do
  click_on "Attachments"
  assert page.has_content?(@attachment.title)
end

When(/^I start drafting a statistical data set$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I add an attachment with additional references$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I save the statistical data set$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I start drafting a publication$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the attachment listed on the form$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I save the publication$/) do
  pending # express the regexp above with the code you wish you had
end
