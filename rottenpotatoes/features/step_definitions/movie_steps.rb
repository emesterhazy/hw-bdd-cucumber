# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do |n_seeds|
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  fail 'Unimplemented'
end

Then /I should (not )?see movies with the following ratings: (.*)/ do |should, ratings_list|
  ratings = ratings_list.delete(' ').split(',')
  ratings.each do |rating|
    Movie.where(rating: rating).each do |mov|
      if !should
        page.should have_content(mov.title)
      else
        page.should_not have_content(mov.title)
      end
    end
  end

end
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.delete(' ').split(',')
  raise_exception
  ratings.each do |rating|
    s = "ratings_#{rating}"
    if uncheck
      uncheck(s)
    else
      check(s)
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  movies = Movie.select(:title)
  movies.each do |mov|
    page.should have_content(mov.title)
  end
end
