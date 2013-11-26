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
# Returns nothing.#
When(/^I fill out the "(.*?)" table(?:| (?:under|in) the "(.*?)" subsection) with:$/)\
  do |table_name, subsection, table|

  kaiki.get_ready
  table_fill(subsection, table_name, table)
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
  table_fill(subsection, table_name, table, :add)
end

# Description: First the starting column of the data is determined based on
#              what the data actually contains.
#              This method uses two if statements to filter through which
#              table it may be filling out.
#              The first if checks if the column name is 'Actions', usually
#              signifying that there is to be a button clicked. Inside this
#              block is a case for the application being used to help speed up
#              process.
#              The next block checks if the column name contains a '@'. If it
#              does, this signifies that there needs to be a search performed
#              here for a value.
#              And then the last block is for everything else in KFS and KC,
#              meaning filling out your general fields within the table.
#              Location awareness, i.e. tab name, and section name are used
#              to further determine the location of the field to be filed in.
#              Using location awareness greatly improves accuracy.
#
# Parameters:
#   subsection_name - name of the subsection the table may appear in
#   table_name      - identifier of the table
#   table           - data to be used
#   options         - for now, a placeholder for ":add", used for adding lines
#                     to an existing table
#
# Returns nothing.
def table_fill(subsection_name, table_name, table, options=nil)
  data_table = table.raw
  header_row = data_table[0]
  max_data_rows = data_table.size - 1
  max_data_columns = header_row.size - 1

  if (options == :add) || (!header_row[0].include?("#"))
    starting_column = 0
  else
    starting_column = 1
  end

  (1..max_data_rows).each do |data_row_counter|
    (starting_column..max_data_columns).each do |data_column_counter|
      row_name = data_table[data_row_counter][0]
      column_name = data_table[0][data_column_counter]
      value = data_table[data_row_counter][data_column_counter]
      if subsection_name == nil
        subsection = row_name
      else
        subsection = subsection_name
      end

      step1="//h2[contains(., '#{@tab}')]"
      step2="/../../../../following-sibling::div/descendant::span[contains(., '#{@section}')]"
      step3="/../../following-sibling::tr/td[contains(text(), '#{subsection}')]"
      step4="/../following-sibling::table/descendant::tr/th[contains(text(), '#{subsection}')]"
      step5="/../following-sibling::table/descendant::"
      step6="/../../../../descendant::tr/td/b[contains(., '#{row_name}')]"
      back1="/../following-sibling::tr/descendant::"
      back2="/../../following-sibling::tr/descendant::"

      if column_name == "Action"
        case kaiki.application
        when "kfs"
# factory0 - KFS PA004-01 (Create Requisition)
          factory0_string = step1 + step2 + step3 + back1 +                    \
            "span[contains(., '#{table_name}')]" + back2 +                     \
            "%s[contains(@title, '#{value}')]"
          factory0 =
            ApproximationsFactory.transpose_build(
              factory0_string,
              ["input"   ],
              ["select"  ],
              ["textarea"])
# factory1 - KFS PA004-01 (Create Requisition)
          factory1_string = step1 + step2 + back2 +                            \
            "%s[contains(@title, '#{value}')]"
          factory1 =
            ApproximationsFactory.transpose_build(
              factory1_string,
              ["input"],
              ["select"],
              ["textarea"])
          @approximate_xpath = factory0                                        \
                             + factory1
        when "kc"
# factory0 - KC Feat. 6 (Non-Personnel)
          factory0_string = step1 + step2 + step5 + "%s"
          factory0 =
              ApproximationsFactory.transpose_build(
                factory0_string,
                ["input[contains(@name, 'add')]"])
          @approximate_xpath = factory0
        else
          factory0 = [nil]
          @approximate_xpath = factory0
        end
        kaiki.click_approximate_field(@approximate_xpath)
        kaiki.pause
        kaiki.switch_default_content
        kaiki.select_frame("iframeportlet")
      elsif value[-1] == "@"
# KFS PA004-01 (Create Requisition)
        value = value.chop
        steps %{
          When I start a lookup for "#{column_name}" in the "#{table_name}" subsection
          And I set "#{column_name}" to "#{value}" on the search page
          And I click the "search" button
          And I return the record with "#{column_name}" of "#{value}" on the search page
          }
      else
        if value != ""
          case kaiki.application
          when "kfs"
# factory0 - KFS PA004-01 (Create Requisition)
            factory0_string = step1 + step2 + step3 + back1 +                  \
              "span[contains(., '#{table_name}')]" + back2 +                   \
              "%s[contains(@title, '#{column_name}')]"
            factory0 =
              ApproximationsFactory.transpose_build(
                factory0_string,
                ["input"   ],
                ["select"  ],
                ["textarea"])
# factory1 - KFS PA004-05 (Payment Request)
# factory1 - KFS PA004-06 (Vendor Credit Memo)
            factory1_string = step1 + step2 + step6 +                          \
              "/../following-sibling::td/descendant::"                         \
              "%s[contains(@title, '#{column_name}')]"
            factory1 =
              ApproximationsFactory.transpose_build(
                factory1_string,
                ["input"],
                ["select"],
                ["textarea"])
# factory2 - KFS PA004-01 (Create Requisition)
            factory2_string = step1 + step2 + back2 +                          \
              "%s[contains(@title, '#{column_name}')]"
            factory2 =
              ApproximationsFactory.transpose_build(
                factory2_string,
                ["input"],
                ["select"],
                ["textarea"])
            @approximate_xpath = factory0                                      \
                               + factory1                                      \
                               + factory2
          when "kc"
            option1 = "input[contains(@title, '#{column_name}')]"
            option2 = "select[contains(@title, '#{column_name}')]"
            option3 = "textarea[contains(@title, '#{column_name}')]"
            option4 = "input[@title='#{column_name} - #{value}']"
            option5 = "select[contains(@name, 'newBudgetLineItems[1]."         \
                      "costElement')]"
            option6 = "select[contains(@name, 'newBudgetLineItems[0]."         \
                      "costElement')]"
# factory0 - KC Feat. 1 (Questions)
# factory0 - KC Feat. 1 (Budget Versions Parameters)
# factory0 - KC Feat. 2 (Time & Money, Commitments)
# factory0 - KC Feat. 3 (Questions)
# factory0 - KC Feat. 3 (Budget Versions Parameters)
# factory0 - KC Feat. 7 (Questions)
# factory0 - KC Feat. 7 (Budget Versions Parameters)
# factory0 - KC Feat. 8 (Budget Versions Parameters)
            factory0_string = step1 + step2 + step4 +                          \
              "/following-sibling::td/descendant::%s"
            factory0 =
              ApproximationsFactory.transpose_build(
                factory0_string,
                [option4],
                [option3],
                [option1],
                [option2])
# factory1 - KC Feat. 2 (Special Review)
            factory1_string = step1 + step2 + step5 + "%s"
            factory1 =
              ApproximationsFactory.transpose_build(
                factory1_string,
                [option6],
                [option5],
                [option3],
                [option1],
                [option2])
            @approximate_xpath = factory0                                      \
                               + factory1
          else
            factory0 = [nil]
            @approximate_xpath = factory0
          end
          kaiki.set_approximate_field(@approximate_xpath, value)
        end
      end
    end
  end
end
