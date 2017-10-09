# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end
 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end
 
# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  #pending  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    db_movie = Movie.where("title = \'#{movie[:title]}\' ")
    if db_movie.blank?
       Movie.create!(movie)
    else
      db_movie.update_attributes!(movie)
    end
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  # pending  #remove this statement after implementing the test step
  all_rates = ['G','PG','PG-13','NC-17','R'];
  opted_rates = arg1.split(',');
  opted_rates.each {|x| x.strip!}
  unopted_rates = all_rates - opted_rates;

  for rate in unopted_rates
    uncheck("ratings[#{rate}]")
  end

  for rate in opted_rates
    check("ratings[#{rate}]")
  end

  click_button('Refresh')

end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  #pending  #remove this statement after implementing the test step
  result = true;
  opted_rates = arg1.split(',');

  all("tr").each do |tr|
    row_check_result = false;
    for rate in opted_rates
      if tr.has_content?(rate)
        row_check_result = true
        break
      end
    end
    if false == row_check_result
       result = false;
       break;
    end
  end

  expect(result).to be_truthy

end

Then /^I should see all of the movies$/ do
  #pending  #remove this statement after implementing the test step
  row_num = 0;
  all("tr").each do |tr|
    row_num += 1
  end
  row_num.should == 11 # include table head
end


When /^I have clicked the "(.*?)" of table head$/ do |table_head|
  click_link (table_head)
end


Then /^I should see "(.*?)" before "(.*?)" in table content$/ do |content1, content2|
  desired_content = [content1, content2];
  got_content = [];
  all("tr").each do |tr|
    if (tr.has_content?(content1) && false == got_content.include?(content1))
      got_content.push(content1);
    end
    if (tr.has_content?(content2) && false == got_content.include?(content2))
      got_content.push(content2);
    end
  end

  expect(got_content).to eq(desired_content)

end
