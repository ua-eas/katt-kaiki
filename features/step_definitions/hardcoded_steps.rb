
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
        kaiki.click_by_xpath(xpath, "radio")
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")   
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
        kaiki.click_by_xpath(xpath, "radio")
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")   
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
        kaiki.click_by_xpath(xpath, "radio")
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")   
      end
    end
  elsif table_name == "PRS Questions"
    table_num = 3                      # 3 for dev, 4 for cdf due to Grants.gov
                                       # Questions not appearing on dev
    table.rows_hash.each do |key, value|    
    newkey = key.to_i + 1
      if value == "Yes"
        td_num = 1
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")
      elsif value == "No"
        td_num = 2
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")    
      elsif value == "N/A"
        td_num = 3
        xpath = "/html/body/form/table/tbody/tr/td[2]/div[2]/div[#{table_num}]"        \
            "/div[3]/table/tbody/tr[#{newkey}]/td[2]/div/span/label[#{td_num}]/input"
        kaiki.click_by_xpath(xpath, "radio")   
      end
    end
  end
end
