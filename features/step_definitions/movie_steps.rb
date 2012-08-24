
# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    
    Movie.find_or_create_by_title(movie[:title], movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  assert movies_table.hashes.size == Movie.all.count
#flunk "Unimplemented"
end

Then /^I should see the following ratings: (.*)/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").map! {|t| t.text}
    rating_list.split(",").each do |field|
        assert ratings.include?(field.strip)
  end
end

Then /^I should not see the following ratings: (.*)/ do |rating_list|
    ratings = page.all("table#movies tbody tr td[2]").map! {|t| t.text}
      rating_list.split(",").each do |field|
          assert !ratings.include?(field.strip)
  end
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
    titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
    assert titles.index(e1) < titles.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list
  ratings.split(",").each do |rating|
    field = "ratings[#{rating.strip.upcase}]"
    if(uncheck)
      uncheck(field)
    else
      check(field)
    end
  end
end

Then /^I should see all of the movies$/ do
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
    assert ( rows.size == Movie.all.count )
end
 
Then /^I should see no movies$/ do
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
    assert rows.size == 0
    end


Then /^the (.+) of "(.+)" should be "(.+)"$/ do |field,title,value|
  # check database
  movie = Movie.find_by_title(title)
  field_value = movie.send(field.to_sym)
  field_value.should be == value
  # check view
  step %{I go to the details page for "#{title}"}
  step %{I should see "#{field.capitalize}: #{field_value}"}
end
