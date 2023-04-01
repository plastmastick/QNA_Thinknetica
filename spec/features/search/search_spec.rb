require 'sphinx_helper'

feature 'User can search for resources', %q{
  In order to find needed resource
  As a User
  I'd like to be able to search for the resource
  } do

  given!(:answer) { create(:answer) }
  given!(:question) { create(:question) }
  given!(:other_answer) { create(:answer, body: 'MyText')}

  background do
    visit questions_path
  end

  scenario 'User searches with no result', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search-form') do
        fill_in 'search_query', with: 'abc'
        page.select('All', from: 'search_type')
        click_on 'Search'
      end
      expect(page).to have_content 'No matches'
    end
  end

  scenario 'User searches for the answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search-form') do
        fill_in 'search_query', with: answer.body
        page.select('Answer', from: 'search_type')
        click_on 'Search'
      end
      expect(page).to have_content(answer.body)
    end
  end


  scenario 'User searches for the question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search-form') do
        fill_in 'search_query', with: question.body
        page.select('Question', from: 'search_type')
        click_on 'Search'
      end
      expect(page).to have_content(question.body)
    end
  end

  scenario 'User searches within all', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within('.search-form') do
        fill_in 'search_query', with: question.body
        page.select('All', from: 'search_type')
        click_on 'Search'
      end

      expect(page).to have_content(question.body)
      expect(page).to have_content(other_answer.body)
    end
  end
end
