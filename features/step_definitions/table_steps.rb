# Description: This file holds all of the step_definitions pertaining
#              to filling out the various tables encountered within the
#              kuali webpages.
#
# Original Date: November 4th, 2013

# Description: Takes the given table's name, possible subsection, and data and
#              calls the table_fill method to fill it out.
#
# Parameters:
#   table_name - name of the table to be filled out
#   subsection - area of the pay it may appear in
#   table      - data to be used
#
# Returns nothing.
When(/^I fill out the "(.*?)" table(?:| (?:under|in) the "(.*?)" subsection) with:$/)\
  do |table_name, subsection, table|

  kaiki.get_ready
  current_page.table_fill(subsection, table_name, table)
end

# Description: Takes the given table's name, possible subsection, and data and
#              calls the table_fill method to fill it out.
#
# Parameters:
#   table_name - name of the table to be filled out
#   subsection - area of the pay it may appear in
#   table      - data to be used
#
# Returns nothing.
When(/^I add to the "([^"]*)" table(?:| (?:under|in) the "(.*?)" subsection) with:$/)\
  do |table_name, subsection, table|

  kaiki.get_ready
  current_page.table_fill(subsection, table_name, table, :add)
end

# Description: Verifies the given values in the table are present
#
# Parameters:
#   table_name - name of the table to be filled in
#   table      - table of data being read in from the feature file
#
# Returns nothing.
Then(/^I should see the "([^"]*)" table filled out with:$/)                    \
  do |table_name, table|

  kaiki.get_ready
  kaiki.should(have_content(table_name))
  current_page.table_verify(table_name, table)
end

# Public: This method may need another ApproximationsFactory segment added
#         but as is, it will fill in an input/select/textarea field in a table
#         given the name of the table.
#
# Parameters:
#   table_name - name of the table
#   row_number - row of the table to be verified
#   table      - data to be used
#
# Returns nothing.
Then(/^I should see the "([^"]*)" table row "([^"]*)" filled with:$/)          \
  do |table_name, row_number, table|

  kaiki.get_ready
  kaiki.should(have_content(table_name))
  data_table = table.raw
  rows = data_table.length-1
  cols = data_table[0].length-1
  (1..rows).each do |data_row_counter|
    (0..cols).each do |data_column_counter|
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      if value != ""
        option1 = "/input[contains(@title, '#{column_name}')]"
        option2 = "/select[contains(@title, '#{column_name}')]"
        option3 = "/textarea[contains(@title, '#{column_name}')]"
        option4 = "[text()[contains(., '#{value}')]]"
        factory1 =
          ApproximationsFactory.transpose_build(
            "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/" \
            "descendant::h3[contains(., '#{table_name}')]/following-sibling::" \
            "table/descendant::th[contains(text(), '#{row_number}')]"          \
            "/following-sibling::td/div%s",
            [option3],
            [option1],
            [option2],
            [option4])
        approximate_xpath = factory1
        element = kaiki.find_approximate_element(approximate_xpath)
        if element[:type] == "text"
          @field_text = element[:value]
        elsif element[:type] == "select-one"
          begin
            @element_option = element.find(:xpath, "option[@selected ='selected']")
          rescue Capybara::ElementNotFound
            @element_option = element.find(:xpath, "option[@value='#{element[:value]}']")
          end
          @field_text = element_option.text
        else
          @field_text = element.text.strip
        end
        print "#{@field_text}\n"
        unless @field_text = value
          raise Capybara::ExpectationNotMet
        end
      end
    end
  end
end

# Public: This step is specific to the Current Funding Proposals section on the
#         Award tab when creating a new award. To guarantee the values show up
#         under the specified headers, this is the best way we can achieve this.
#         All the data is pulled from the page section, and then our table
#         data is verified against it.
#
# Parameters:
#   table - table of headers and values that should appear in the sections
#
# Returns nothing.
Then(/^I should see the Current Funding Proposals table filled out with:$/)    \
  do |table|

  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  #There are 9 columns on the page. For now this is the easiest way to run this loop.
  (0..8).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[1]/th[#{data_row_counter+1}]/div").text.strip
    data_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[2]/td[#{data_row_counter+1}]").text.strip
    data_hash.store(header_value, data_value)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    if data_hash[header_name].include?(value)
      print "#{data_hash[header_name]}\n"
      kaiki.highlight(
          :xpath,
          "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"   \
          "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"\
          "descendant::td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# Public: This step is specific to the Current Funding Proposals section on the
#         Award tab when creating a new award. To guarantee the values show up
#         under the specified headers, this is the best way we can achieve this.
#         All the data is pulled from the page section, and then our table
#         data is verified against it.
#
# Parameters:
#   table - table of headers and values that should appear in the sections
#
# Returns nothing.
Then(/^I should see the Sponsor Contacts table filled out with:$/) do |table|
  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  #There are 5 columns on the page. For now this is the easiest way to run this loop.
  (0..4).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
      "descendant::h3[contains(., '#{@section}')]/following-sibling::table/"   \
      "tbody/tr[1]/th[#{data_row_counter+2}]").text.strip
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[3]/td[#{data_row_counter+1}]/%s",
        ['div/select'],
        ['div'],
        ['div/input'])

    data_element = kaiki.find_approximate_element(factory0)

    if data_element[:type] == "select-one"
      begin
        @element_option = data_element.find(:xpath, "option[@selected ='selected']")
      rescue Capybara::ElementNotFound
        @element_option = data_element.find(:xpath, "option[@value='#{data_element[:value]}']")
      end
      @data_value = @element_option.text
    elsif data_element[:type] == "text"
      @data_value = data_element[:value]
    else
      @data_value = data_element.text.strip
    end

    data_hash.store(header_value, @data_value)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    data_hash.each_key { |key| header_name = key if key.include?(header_name) }

    if data_hash[header_name].include?(value)
      print "#{data_hash[header_name]}\n"
      kaiki.highlight(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::tr[3]/td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end

# Public: This step is specific to the Budget Versions table, to guarantee the
#         values show up under the specified headers, this is the best way we
#         can achieve this. All the data is pulled from the page section, and
#         then our table data is verified against it.
#
# Parameters:
#   table - table of headers and values that should appear in the sections
#
# Returns nothing.
Then(/^I should see the Budget Versions table filled out with:$/) do |table|

  kaiki.get_ready

  data_table = table.raw
  data_hash = Hash.new

  #There are 8 columns on the page we want to verify. For now this is the easiest way to run this loop.
  (0..7).each do |data_row_counter|
    header_value = kaiki.find(
      :xpath,
      "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"       \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "thead/tr[1]/th[#{data_row_counter+1}]").text.strip
    factory0 =
      ApproximationsFactory.transpose_build(
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "tbody/tr[1]/td[#{data_row_counter+1}]%s",
        ['/div/select'],
        ['/div/input'],
        ['/div'],
        [''])
    data_element = kaiki.find_approximate_element(factory0)
    if data_element[:type] == "select-one"
      begin
        @element_option = data_element.find(:xpath, "option[@selected ='selected']")
      rescue Capybara::ElementNotFound
        @element_option = data_element.find(:xpath, "option[@value='#{data_element[:value]}']")
      end
      @data_value = @element_option.text
    elsif data_element[:type] == "text"
      @data_value = data_element[:value]
    elsif data_element[:type] == "checkbox"
      @data_value = data_element[:checked]
      if @data_value == nil
        @data_value = "unchecked"
      else
        @data_value = "checked"
      end
    else
      @data_value = data_element.text.strip
    end
    data_hash.store(header_value, @data_value)
  end
  rows = data_table.length-1
  (0..rows).each do |data_row_counter|
    header_name = data_table[data_row_counter][0]
    value = data_table[data_row_counter][1]
    data_hash.each_key { |key| header_name = key if key.include?(header_name) }
    if data_hash[header_name].include?(value)
      print "#{data_hash[header_name]}\n"
      kaiki.highlight(
        :xpath,
        "//h2[contains(., '#{@tab}')]/../../../../following-sibling::div/"     \
        "descendant::h3[contains(., '#{@section}')]/following-sibling::table/" \
        "descendant::tr[1]/td[contains(., '#{value}')]")
    else
      raise Capybara::ExpectationNotMet
    end
  end
end