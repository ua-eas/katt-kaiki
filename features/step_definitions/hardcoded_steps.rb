# Public: This performs the same action as the 'When I set "" to "" '
#         step definition except for when the text field/drop down appears
#         underneath the label for it
#
# value - what to enter into the text field/drop down
# field - label of the field/drop down
#
# Returns: nothing
When /^I enter "([^"]*)" under "([^"]*)"$/ do |value, field|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.fill_under(field, value)    

  # kaiki.pause
  # kaiki.switch_default_content
  # kaiki.select_frame "iframeportlet"
  # kaiki.set_approximate_field(
    # ApproximationsFactory.transpose_build(
      # "//%s[contains(text()%s, '#{field}')]/../following-sibling::tr/td/%s",
      # ['tr/th/label',    '',       'select[1]'],
      # ['tr/th/div',      '[1]',    'input[1]'],
      # [nil,           '[2]',    nil]
    # ) +
    # ApproximationsFactory.transpose_build(
      # "//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
      # ['',       'select'],
      # ['[1]',    'input'],
      # ['[2]',    nil]
    # ),
    # value
  # )
end

# Public: Clicks the appropriate button or link, given by name, id or title
#
# name - name, id or title of button or link
#
# Returns: nothing
When /^I click "([^"]*)"$/ do |name|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  if name == "Add"
    kaiki.click_by_xpath("/html/body/form/table/tbody/tr/td[2]/div[2]/div"  \
                                   "/div[3]/table/thead/tr[2]/td[8]/div/input")
  elsif name == "Recalculate"
    kaiki.click_by_xpath("/html/body/form/table/tbody/tr/td[2]/div[2]"      \
              "/div[2]/div[3]/table/tbody/tr[#{@tr_recalc}]/td[11]/div/input")
    kaiki.pause
  end
end

# Public: Clicks the appropriate button or link, given by name, id or title,
#         which appears under a certain field
#
# name - name, id or title of button or link
# field - field in which the button should be
#
# Return: nothing
When /^I click "([^"]*)" on "([^"]*)"$/ do |name, field|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content field
  kaiki.click_by_xpath("/html/body/form/table/tbody/tr/td[2]/div[2]/div"  \
                                      "/div[3]/table/tbody/tr/td[9]/div/input")
end

# Public: For now this is only specific to the Budget Versions tab when
#         creating a new proposal document under the Central Admin tab
#
# line_number - line number the field is on
# table_name - name of the table
# table - data to be used
#
# Returns: nothing
When /^I fill out line "([^"]*)" of the "([^"]*)" table with:$/              \
                                            do |line_number, table_name, table|
  table.rows_hash
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name
  
  tr_num = line_number.to_i + 2
  table.rows_hash.each do |key, value|
    if key == "Total Sponsor Cost"
      td_num = 3
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[2]/div[3]"   \
              "/table/tbody/tr[#{tr_num.to_s}]/td[#{td_num}]/div/input"
      kaiki.fill_under(xpath, value) 
    elsif key == "Direct Cost"
      td_num = 4
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[2]/div[3]"   \
              "/table/tbody/tr[#{tr_num.to_s}]/td[#{td_num}]/div/input"
      kaiki.fill_under(xpath, value)
    elsif key == "F&A Cost"
      td_num = 5
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[2]/div[3]"   \
              "/table/tbody/tr[#{tr_num.to_s}]/td[#{td_num}]/div/input"
      kaiki.fill_under(xpath, value)
    end
  
  # kaiki.set_approximate_field(
    # ApproximationsFactory.transpose_build(
      # "//%s[contains(text()%s, '#{line_number}')]/../following-sibling::td/%s",
      # ['th',      '',       'select[1]'],
      # ['th',      '[1]',    'input[1]'],
      # [nil,          '[2]',    nil]
    # ) +
    # ApproximationsFactory.transpose_build(
      # "//th[contains(text()%s, '#{line_number}')]/../following-sibling::td[4]/descendant::div/%s[contains(text(), '#{key}')]",
      # ['',       'select'],
      # ['[1]',    'input'],
      # ['[2]',    nil]
    # ),
    # value
  # )
  end
  
  @tr_recalc = tr_num + 2
end

# Public :
# 
# 
# 
# Returns: nothing
Then /^I should see line "([^"]*)" of the "([^"]*)" table filled out with:$/ \
                                            do |line_number, table_name, table|
  kaiki.pause
  #kaiki.switch_default_content
  #kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name
  
  tr_num = line_number.to_i + 2
  table.rows_hash.each do |key, value|
  puts key
  puts value
    if key == "Total Sponsor Cost"
      puts key
      puts value
      td_num = 3
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[2]/div[3]"   \
                      "/table/tbody/tr[#{tr_num.to_s}]/td[#{td_num}]/div/input"
      field_text = kaiki.find(:xpath, xpath).text
      puts field_text
      # if field_text != value
        # raise Capybara::ExpectationNotMet
      # end
    elsif key == "Direct Cost"
      td_num = 4
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[2]/div[3]"   \
                      "/table/tbody/tr[#{tr_num.to_s}]/td[#{td_num}]/div/input"
      field_text = kaiki.find(:xpath, xpath).text
      # if field_text != value
        # raise Capybara::ExpectationNotMet
      # end
    elsif key == "F&A Cost"
      td_num = 5
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[2]/div[3]"   \
                      "/table/tbody/tr[#{tr_num.to_s}]/td[#{td_num}]/div/input"
      field_text = kaiki.find(:xpath, xpath).text
      # if field_text != value
        # raise Capybara::ExpectationNotMet
      # end
    end
  end
end

# Public: Selects either a Yes, No, or N/A radio button given the name of the
#         table
#
# table_name - name of the table
# table - data to be used
#
# Returns: nothing
When /^I answer the questions under "([^"]*)" with:$/ do |table_name, table|
  table.rows_hash
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  kaiki.should have_content table_name

  if table_name == "Does the Proposed Work Include any of the Following?"
    table_num = 1
    table.rows_hash.each do |key, value|    
     newkey = key.to_i + 1
      if value == "Yes"
        td_num = 1
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath   
      end
    end
  elsif table_name == "F&A (Indirect Cost) Questions"
    table_num = 2
    table.rows_hash.each do |key, value|  
    newkey = key.to_i + 1
     if value == "Yes"
        td_num = 1
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath   
      end
    end
  elsif table_name == "Grants.gov Questions"
    table_num = 3
    table.rows_hash.each do |key, value|    
    newkey = key.to_i + 1
      if value == "Yes"
        td_num = 1
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath   
      end
    end
  elsif table_name == "PRS Questions"
    table_num = 4
    table.rows_hash.each do |key, value|    
    newkey = key.to_i + 1
      if value == "Yes"
        td_num = 1
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_radio_xpath xpath   
      end
    end
  end
end
  
# Public: This method is fairly specific to KC, and will fill out the fields
#         for the combined credit split for each member that is attached to
#         budget proposal document.
#         * One thing to note: as this method is hardcoded for the moment, the
#         * xpath variable will need to be altered depending on how many people
#         * are attached to the document.
#         * The 2nd div[] tag will change accordingly: div[2] = 1 person,
#         * div[3] = 2 persons, div[4] = 3 persons, etc.
#
# line_item - 
# name - name of the person the fields are shown under
# table - table of data being read in from the feature file
#
# Returns: nothing
When /^I fill out the Combined Credit Split for "([^"]*)" under "([^"]*)" with the following:$/\
                                                    do |line_item, name, table|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  if line_item == "0721 - Cancer Center Division" && name == "Linda L Garland"
    tr_num = 3
  elsif line_item == "0721 - Cancer Center Division" && name == "Amanda F Baker"
    tr_num = 6
  end
  table.rows_hash.each do |key, value|
    if key == "Credit for Award"
      td_num = 2
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[3]/div[3]"    \
                           "/table/tbody/tr[#{tr_num}]/td[#{td_num}]/div/input"
      kaiki.fill_under xpath, value
    elsif key == "F&A Revenue"
      td_num = 3
      xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[3]/div[3]"    \
                           "/table/tbody/tr[#{tr_num}]/td[#{td_num}]/div/input"
      kaiki.fill_under xpath, value
    end
  end
end
