# Public: Clicks on "Show/Hide" on the specific tab
#
# Parameters: 
#   option - "Show" or "Hide"
#   value - Which tab is being toggled
#
# Returns: nothing
When(/^I click "(.*?)" on the "(.*?)" section$/) do |option, section|
  kaiki.pause
  if option == "Show"
    print kaiki.find(:xpath, "//input[@title='open #{section}']")
    kaiki.show_tab section 
  elsif option == "Hide"
    kaiki.hide_tab section
  else
    raise NotImplementedError
  end
end

# Public: Returns the chosen result from a search query
#
# column - the column to look in
# value  - result to be returned
#
# Returns: nothing
#
 When(/^I return the record with "(.*?)" of "(.*?)"$/) do |column, value|
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
#KcPerson Id  : /html/body/form/table/tbody/tr/td[2]/table/thead/tr/th[2]/a
#return"        /html/body/form/table/tbody/tr/td[2]/table/tbody/tr[2]/td/a
#value:         /html/body/form/table/tbody/tr/td[2]/table/tbody/tr[2]/td[2]/a
  field = column
     kaiki.set_approximate_field(
     ApproximationsFactory.transpose_build(
       "//%s[contains(text()%s, '#{field}')]/../following-sibling::td/%s",
       ['th/label',    '',       'select[1]'],
       ['th/div',      '[1]',    'input[1]'],
       [nil,           '[2]',    nil]
     ) +
     ApproximationsFactory.transpose_build(
       "//th[contains(text()%s, '#{field}')]/../following-sibling::tr/td/div/%s[contains(@title, '#{field}')]",
       ['',       'select'],
       ['[1]',    'input'],
       ['[2]',    nil]
     ) + 
     ApproximationsFactory.transpose_build(
       "//th/div[contains(text()%s, '#{field}')]/../following-sibling::td/span/%s[contains(@title, '#{field}')]",
       ['',       'input'],
       ['[1]',    nil],
       ['[2]',    nil]
     ),
     value
   )
   
  kaiki.click "search"
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
  link = kaiki.find('a', :text => 'return value')
  link.click

end

When(/^I fill out the Combined Credit Split for "(.*?)" with the following:$/) do |name, table|
  # table is a Cucumber::Ast::Table
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
#  print "Name: #{name}\n"
#  print "Table: #{table}\n"
  data = table.raw
#  print "Data: #{data}\n"
  data.each do |key, value|
    if key == "Credit for Award"
      data_column = 1
    elsif key == "F&A Revenue"
      data_column = 2
    else
      data_column = nil
      raise NotImplementedError
    end
    if data_column != nil
      approximation_string = 'td[' + data_column.to_s + ']/div/strong/input'
      xpath = ApproximationsFactory.transpose_build(
                "//%s[contains(text(),'#{name}')]/../following-sibling::%s",
                ['td/strong', approximation_string],
                [nil,         nil],
                [nil,         nil]
                )
      kaiki.set_approximate_field(xpath, value)
    end
  end
end




When(/^I fill out the Combined Credit Split line item for "(.*?)" under "(.*?)" with the following:$/) do |lineitem, name, table|
  # table is a Cucumber::Ast::Table
  kaiki.pause
  kaiki.switch_default_content
  kaiki.select_frame "iframeportlet"
#  print "Name: #{name}\n"
#  print "Table: #{table}\n"
  data = table.raw
#  print "Data: #{data}\n"
  data.each do |key, value|
#    if key == "Credit for Award"
#      data_column = 1
#    els
    if key == "F&A Revenue"
      data_column = 2
    else
      data_column = nil
      raise NotImplementedError
    end
    if data_column != nil
      approximation_string = 'td[' + data_column.to_s + ']/div/input'
      partial_xpath = ApproximationsFactory.transpose_build(
                "//%s[contains(text(),'#{name}')]/../following-sibling::%s[contains(text(),'#{lineitem}')]",
                ['tr/td/strong', 'tr/td'],
                [nil,            nil,    ],
                [nil,            nil,    ]
                )
      print "Xpath: #{partial_xpath.to_s}"
      xpath = ApproximationsFactory.transpose_build(
                "//%s/../child::%s",
                [partial_xpath.to_s, approximation_string],
                [nil,            nil,    ],
                [nil,            nil,    ]
                )
      print "Xpath: #{xpath}"
      kaiki.set_approximate_field(xpath.to_s, value)
      kaiki.pause 30
    end
  end
end
#                "//%s[contains(text(),'#{name}')]/../following-sibling::%s[contains(text(),'#{lineitem}')]/../child::%s",
#  Linda L Garland:              /html/body/form/table/tbody/tr/td[2]/div[2]/div[3]/div[3]/table/tbody/tr[2]/td/strong
# 0721 - Cancer Center Division  /html/body/form/table/tbody/tr/td[2]/div[2]/div[3]/div[3]/table/tbody/tr[3]/td
# Credit for Award               /html/body/form/table/tbody/tr/td[2]/div[2]/div[3]/div[3]/table/tbody/tr[3]/td[2]/div/input
# F&A Revenue                    /html/body/form/table/tbody/tr/td[2]/div[2]/div[3]/div[3]/table/tbody/tr[3]/td[3]/div/input


