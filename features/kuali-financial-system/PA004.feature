@PA004
  Feature: PA004

  Description:
  	01    - Create a requisition to a Sales Tax Vendor without Receiving;
            use multiple lines and quantity.
    02    - Assigns a contract manager to a requisition.
    03/04 - Create a purchase order and print a purchase order.
            This test assumes PA004-01 and PA004-02 have been completed.
    05    - Submits a payment request, testing 4 different methods.
            This test assumes PA004-01, PA004-02 and PA004-0304 have been
            previously run.
    06    - Creates a credit memo for the ACH/Check payment method performed
            in PA004-05.
            This test assumes PA004-01, PA004-02, PA004-0304 and
            PA004-05 have been previously run.

  Background:
  	Given I am up top

  @Day1 @PA004-01
  Scenario: Create Requisition

  Given I am on the "Main Menu" system tab
    And I am logged in as "kfs-test-sec1"
  When I click the "Requisition" link
    And I am on the "Requisition" page
    And I click the "Collapse All" button


  When I click "Show" on the "Document Overview" tab
    And I am in the "Document Overview" section
    And I set "Description" to "PA-004"
    And I am in the "Requisition Detail" section
    And I start a lookup for "Chart/Org"
    And I set "Organization Code" to "9507" on the search page
    And I click the "Search" button on the search page
    And I return the record with "Organization Code" of "9507" on the search page
  Then I should see "Chart/Org" text set to "UA  /  9507"
    And I should see "Funding Source" set to "INSTITUTION ACCOUNT"
  When I click "Hide" on the "Document Overview" tab


  When I click "Show" on the "Delivery" tab
    And I am in the "Final Delivery" section
    And I start a lookup for "Building"
    And I set "Building Code" to "300A" on the search page
    And I click the "Search" button on the search page
    And I return the record with "Building Code" of "300A" on the search page
    And I start a lookup for "Room"
    And I set "Building Room Number" to "A502" on the search page
    And I click the "Search" button on the search page
    And I return the record with "Room" of "A502" on the search page
  Then I should see "Delivery To" set to "Security User1"
    And I should see "Phone Number" set to "345-876-6579"
  When I set "Email" to "testID@fakeserver.edu"
    And I set "Date Required" to "01/01/2020"
    And I set "Date Required Reason" to "ESTIMATED DATE"
    And I am in the "Receiving Address" section
    And I start a lookup for "Receiving Address"
    And I click the "clear" button on the search page
    And I click the "search" button on the search page
    And I return the record with "Receiving Name" of "Main Campus" on the search page
    And I am in the "Address To Vendor" section
    And I click the "Final Delivery Address" radio button
    And I click "Hide" on the "Delivery" tab


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I start a lookup for "Suggested Vendor"
    And I set "Vendor #" to "18360-0" on the search page
    And I click the "Search" button on the search page
    And I return the record with "Vendor #" of "18360-0" on the search page
    And I am in the "Additional Suggested Vendor Names" section
    And I set "Vendor Name 1" to "VWR International"
    And I click "Hide" on the "Vendor" tab


  Then I click "Show" on the "Items" tab
  When I am in the "Add Item" section
    And I add to the "Add Item" table with:
      | Item Type        | Quantity | Unit Of Measure Code | Catalog # | Description       | Unit Cost | Action |
      | QUANTITY TAXABLE | 10       | EA@                  | 123-ABC   | Bunny Slippers    | 6         | Add    |
      | QUANTITY TAXABLE | 10       | BX                   | 333-FRG   | Frog Hats         | 5.50      | Add    |
      | QUANTITY TAXABLE | 10       | PR                   | 399-PIG   | Pig Lipstick      | 9.00      | Add    |
      | QUANTITY TAXABLE | 10       | BX                   | 553-BGG   | Ladybug Tap Shoes | 12.50     | Add    |
      | QUANTITY TAXABLE | 12       | EA                   | 311-RBT   | Robot Cufflinks   | 2.45      | Add    |
    And I am in the "Current Items" section
    And I fill out the "Accounting Lines" table with:
      | Item # | Chart | Account Number | Object | Percent | Action |
      | Item 1 | UA    | 1732100        | 5230   | 100     | Add    |
      | Item 2 | UA    | 1732100        | 5230   | 100     | Add    |
      | Item 3 | UA    | 1732100        | 5230   | 100     | Add    |
      | Item 4 | UA    | 1732100        | 5230   | 100     | Add    |
      | Item 5 | UA    | 1732100        | 5230   | 100     | Add    |
    And I click "Show" on the "Additional Charges" section
    And I am in the "Additional Charges" section
    And I set "Description" to "Freight" in the "FREIGHT" subsection
    And I set "Extended Cost" to "10" in the "FREIGHT" subsection
    And I fill out the "Accounting Lines" table in the "FREIGHT" subsection with:
      | Chart | Account Number | Object | Percent | Action |
      | UA    | 1732100        | 5560   | 100     | Add    |
    And I click "Hide" on the "Items" tab


  When I click "Show" on the "Additional Institutional Info" tab
    And I am in the "Additional" section
  Then I should see "Method of PO Transmission" set to "PRINT"
    And I should see "Requestor Name" set to "Security User1"
    And I should see "Requestor Phone" set to "345-876-6579"
  When I set "Requestor Email" to "testID@fakeserver.edu"
    And I click "Hide" on the "Additional Institutional Info" tab


  When I click "Show" on the "Account Summary" tab
    And I am in the "Account Summary" section
    And I should not see the message "No Accounts"
    And I click "Hide" on the "Account Summary" tab


  When I click "Show" on the "Notes and Attachments" tab
    And I am in the "Notes and Attachments" section
    And I set "Note Text" to "Purchasing Supplies for annual Animal-Robot Summit"
    And I click "Add" on "Notes and Attachments"
    And I click "Hide" on the "Notes and Attachments" tab


  When I click "Show" on the "Items" tab
    And I am in the "Add Item" section
    And I click the "clear all tax" button
    And I click the "Calculate" button
    And I click the "Submit" button
    And I should see the message "Document was successfully submitted."


  When I click "Show" on the "Route Log" tab
    And I click "Show" on the "Future Action Requests" tab
    And I record this "Document" number in the document header
    And I record this "requisition" number in the document header
    And I click the "Close" button


  Given I am logged in as "kfs-test-sys10"
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button on the search page
    And I open the saved document with "Document/Notification Id" of "the recorded document number" on the search page
  Then a new browser window appears
    And I click the "approve" button
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button on the search page
    And I open the saved document with "Document/Notification Id" of "the recorded document number" on the search page
  Then a new browser window appears
    And I should see "Status" text set to "FINAL" in the document header
    And I should see "Requisition Status" text set to "Awaiting Contract Manager Assignment" in the document header
  When I close all extra browser windows


  @Day1 @PA004-02
  Scenario: Assigns a contract manager

  Given I am on the "Main Menu" system tab
    And I am logged in as "kfs-test-sec40"
  When I click the "Contract Manager Assignment" link
    And I am in the "Document Overview" tab
    And I should see "Description" set to "Contract Manager Assigned"


  When I am in the "Assign A Contract Manager" tab
    And I should see a table row with a Requisition Number of "the recorded requisition number"
  When I start a lookup for "Contract Manager"
    And I set "Contract Manager Code" to "13" on the search page
    And I click the "Search" button
    And I return the record with "Contract Manager Code" of "13"
  Then I click the "Submit" button
    And I should see the message "Document was successfully submitted."
    And I click the "Reload" button


  When I click "Show" on the "Route Log" tab
    And I should see "Status" text set to "FINAL"



  @Day1 @PA004-0304
  Scenario: Create and Print PO

  Given I am on the "Main Menu" system tab
    And I am backdoored as "kfs-test-sec40"
  When I click the "Purchase Orders" link
    And I set "Type" to "PO" on the search page
    And I start a lookup for "Contract Manager" on the search page
    And I set "Contract Manager Code" to "13" on the search page
    And I click the "Search" button
    And I return the record with "Contract Manager Code" of "13"
    And I set "Requisition #" to "the recorded requisition number" on the search page
    And I click the "Search" button
    And I select the first document on the search page
  Then a new browser window appears
    And I click the "Collapse All" button


  When I click "Show" on the "Document Overview" tab
    And I am in the "Document Overview" section
    And I should see "Description" set to "PA-004"
    And I am in the "Purchase Order Detail" section
    And I should see "Chart/Org" text set to "UA  /  9507"
    And I should see the "Receiving Required" checkbox is "unchecked"
    And I should see "Contract Manager" text set to "Lila R. Sorensen"
    And I should see "Use Tax Indicator" text set to "No"
    And I should see "Funding Source" text set to "INSTITUTION ACCOUNT"
    And I should see the "Payment Request Positive Approval Required" checkbox is "unchecked"
    And I should see "Requisition Source" text set to "DIRECT INPUT"
    And I click "Hide" on the "Document Overview" tab


  When I click "Show" on the "Delivery" tab
    And I am in the "Final Delivery" section
    And I should see "Delivery Campus" text set to "MC"
    And I should see "Address 1" text set to "220 W 6 St"
    And I should see "Room" set to "A502"
    And I should see "City" text set to "TUCSON"
    And I should see "Country" text set to "UNITED STATES"
    And I should see "Delivery To" set to "Security User1"
    And I am in the "Receiving Address" section
    And I start a lookup for "Receiving Address"
    And I click the "clear" button
    And I click the "search" button
    And I return the record with "Receiving Name" of "Main Campus"
    And I am in the "Address To Vendor" section
    And I should see "Shipping Address Presented to Vendor (use Receiving Address?)" radio button set to "Final Delivery Address"
    And I click "Hide" on the "Delivery" tab


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I should see "Vendor #" text set to "18360-0"
    And I am in the "Vendor Info" section
    And I set "Vendor Choice" to "Contracted Price"
    And I click "Hide" on the "Vendor" tab


  When I click "Show" on the "Stipulations" tab
    And I am in the "Vendor Stipulations and Information" section
    And I start a lookup for "Note Text"
    And I set "Vendor Stipulation Name" to "085" on the search page
    And I click the "Search" button
    And I return the record with "Vendor Stipulation Name" of "085"
    And I click the "Add" button
    And I set "Note Text" to "Rush Order"
    And I click the "Add" button
    And I click "Hide" on the "Stipulations" tab


  When I click "Show" on the "Items" tab
    And I am in the "Current Items" section
    And I should see the "Current Items" table filled out with:
      | Item # |  Item Type        | Quantity | Unit Of Measure Code | Catalog # | Description       | Unit Cost |
      | Item 1 |  QUANTITY TAXABLE | 10.00    | EA                   | 123-ABC   | Bunny Slippers    | 6.00      |
      | Item 2 |  QUANTITY TAXABLE | 10.00    | BX                   | 333-FRG   | Frog Hats         | 5.50      |
      | Item 3 |  QUANTITY TAXABLE | 10.00    | PR                   | 399-PIG   | Pig Lipstick      | 9.00      |
      | Item 4 |  QUANTITY TAXABLE | 10.00    | BX                   | 553-BGG   | Ladybug Tap Shoes | 12.50     |
      | Item 5 |  QUANTITY TAXABLE | 12.00    | EA                   | 311-RBT   | Robot Cufflinks   | 2.45      |
    And I click "Show" on the "Accounting Lines" subsection
    And I click "Hide" on the "Items" tab


  When I click "Show" on the "Additional Institutional Info" tab
    And I am in the "Additional" section
  Then I should see "Method of PO Transmission" set to "PRINT"
    And I should see "Cost Source" set to "ESTIMATE"
    And I should see "Requestor Name" set to "Security User1"
    And I should see "Requestor Phone" set to "345-876-6579"
    And I should see "Requestor Email" set to "testID@fakeserver.edu"
    And I click "Hide" on the "Additional Institutional Info" tab


  When I click "Show" on the "Notes and Attachments" tab
    And I set "Note Text" to "Order for Dr. Jones"
    And I click the "Add" on "Notes and Attachments"
    And I click "Hide" on the "Notes and Attachments" tab


  When I click "Show" on the "Ad Hoc Recipients" tab
    And I set "Action Requested" to "FYI" in the "Person Requests" subsection
    And I start a lookup for "Person"
    And I set "Principal Name" to "kfs-test-sec9" on the search page
    And I click the "Search" button
    And I return the record with "Principal Name" of "kfs-test-sec9"
    And I click the "Add" button in the "Person Requests" subsection
    And I click "Hide" on the "Ad Hoc Recipients" tab


  Then I click the "calculate" button
    And I click the "Submit" button
    And I click the "Reload" button
    And I should see "Purchase Order Status" text set to "Pending Print" in the document header
    And I click the "Print" button
    And a new browser window appears
  When I slow down by a lot
  #PDF should open, it is reviewed and then print the PDF
  Then I switch to the 2nd browser window
  When I am fast

  When I click "Show" on the "Route Log" tab
    And I should see "Status" text set to "FINAL"
    And I record this "Purchase Order" number in the document header
    And I record this "Purchase Order Document" number in the document header
  Then I click the "Close" button
  When I close all extra browser windows



  @Day1 @PA004-05
  Scenario: Payment Request with Sales Tax

  #========================Test AP Credit Card Payment Method===================
  Given I am on the "Central Admin" system tab
  Given I am logged in as "kfs-test-sec36"
  When I click the "Payment Request" link
    And I am in the "Payment Request Initiation" tab
    And I set "Purchase Order #" to "the recorded purchase order number"
    And I set "Invoice Number" to "11223344"
    And I set "Invoice Date" to "Today's Date"
    And I set "Vendor Invoice Amount" to "100"
    And I click the "continue" button
  # #Clicking Yes is needed if you are reusing the same Invoice Number or
  # # Vendor Invoice Amount
    # And I click the "Yes" button


  When I am in the "Document Overview" tab
    And I am in the "Payment Request Detail" section
    And I should see "Use Tax Indicator" text set to "No"
    And I click the "Collapse All" button


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I should see "Vendor #" text set to "18360-0"
    And I click "Hide" on the "Vendor" tab


  When I click "Show" on the "Invoice Info" tab
    And I should see "Invoice Number" text set to "11223344"
    And I should see "Invoice Date" text set to "Today's Date"
    And I should see "Purchase Order" text set to "the recorded purchase order number"
    And I set "Pay Date" to "Today's Date"
    And I should see the "Immediate Pay" checkbox is "unchecked"
    And I set "Payment Method Code" to "C - AP Credit Card"
    And I click "Hide" on the "Invoice Info" tab


  When I click "Show" on the "Process Items" tab
    And I am in the "Items" section
    And I fill out the "Items" table with:
      | Item # | Quantity Invoiced |
      | 1      | 1                 |
      | 2      | 1                 |
      | 3      | 1                 |
      | 4      | 1                 |
      | 5      | 1                 |
    And I should see the "Items" table filled out with:
      | Item # |  Unit Cost |
      | 1      |  6.00      |
      | 2      |  5.50      |
      | 3      |  9.00      |
      | 4      |  12.50     |
      | 5      |  2.45      |
    And I click the "clear all tax" button
    And I click the "calculate" button
    And I am in the "Additional Charges" section
    And I record the "[Vendor Remit Amount]" amount
    And I click "Hide" on the "Process Items" tab


  When I click "Show" on the "Account Summary" tab
    And I click the "refresh account summary" button
    And I click "Hide" on the "Account Summary" tab


  When I click "Show" on the "1099 Classification" tab
    And I should see "Total" text set to "[Vendor Remit Amount]"
    And I click the "save" button
    And I should see the message "Document was successfully saved."
    And I record this "document" number in the document header
  Then I click the "Submit" button
    And I click the "yes" button


  Given I am logged in as "kfs-test-sys10"
    And I am on the "Main Menu" system tab
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I click the "approve" button
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I should see "Status" text set to "FINAL" in the document header
    And I should see "Payment Request Status" text set to "Department-Approved" in the document header
  When I close all extra browser windows

  #========================Test Wire Transfer Payment Method====================
  Given I am on the "Central Admin" system tab
    And I am logged in as "kfs-test-sec36"
  When I click the "Payment Request" link
    And I am in the "Payment Request Initiation" tab
    And I set "Purchase Order #" to "the recorded purchase order number"
    And I set "Invoice Number" to "11223345"
    And I set "Invoice Date" to "Today's Date"
    And I set "Vendor Invoice Amount" to "100"
    And I click the "continue" button
    And I click the "Yes" button


  When I am in the "Document Overview" tab
    And I am in the "Payment Request Detail" section
    And I should see "Use Tax Indicator" text set to "No"
    And I click the "Collapse All" button


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I should see "Vendor #" text set to "18360-0"
    And I click "Hide" on the "Vendor" tab


  When I click "Show" on the "Invoice Info" tab
    And I should see "Invoice Number" text set to "11223345"
    And I should see "Invoice Date" text set to "Today's Date"
    And I should see "Purchase Order" text set to "the recorded purchase order number"
    And I set "Pay Date" to "Today's Date"
    And I should see the "Immediate Pay" checkbox is "unchecked"
    And I set "Payment Method Code" to "W - Wire Transfer"
    And I click "Hide" on the "Invoice Info" tab


  When I click "Show" on the "Process Items" tab
    And I am in the "Items" section
    And I fill out the "Items" table with:
      | Item # | Quantity Invoiced |
      | 1      | 1                 |
      | 2      | 1                 |
      | 3      | 1                 |
      | 4      | 1                 |
      | 5      | 1                 |
    And I should see the "Items" table filled out with:
      | Item # |  Unit Cost |
      | 1      |  6.00      |
      | 2      |  5.50      |
      | 3      |  9.00      |
      | 4      |  12.50     |
      | 5      |  2.45      |
    And I click the "clear all tax" button
    And I click the "calculate" button
    And I am in the "Additional Charges" section
    And I record the "[Vendor Remit Amount]" amount
    And I click "Hide" on the "Process Items" tab


  When I click "Show" on the "Account Summary" tab
    And I click the "refresh account summary" button
    And I click "Hide" on the "Account Summary" tab


  When I click "Show" on the "1099 Classification" tab
    And I should see "Total" text set to "[Vendor Remit Amount]"
    And I click the "save" button
    And I should see the message "Document was successfully saved."
    And I record this "document" number in the document header
  Then I click the "Submit" button
    And I click the "yes" button


  Given I am logged in as "kfs-test-sys10"
    And I am on the "Main Menu" system tab
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I click the "approve" button
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I should see "Status" text set to "FINAL" in the document header
    And I should see "Payment Request Status" text set to "Department-Approved" in the document header
  When I close all extra browser windows

  #========================Test Manual Check Payment Method=====================
  Given I am on the "Central Admin" system tab
    And I am logged in as "kfs-test-sec36"
  When I click the "Payment Request" link
    And I am in the "Payment Request Initiation" tab
    And I set "Purchase Order #" to "the recorded purchase order number"
    And I set "Invoice Number" to "11223347"
    And I set "Invoice Date" to "Today's Date"
    And I set "Vendor Invoice Amount" to "100"
    And I click the "continue" button
    And I click the "Yes" button


  When I am in the "Document Overview" tab
    And I am in the "Payment Request Detail" section
    And I should see "Use Tax Indicator" text set to "No"
    And I click the "Collapse All" button


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I should see "Vendor #" text set to "18360-0"
    And I click "Hide" on the "Vendor" tab


  When I click "Show" on the "Invoice Info" tab
    And I should see "Invoice Number" text set to "11223347"
    And I should see "Invoice Date" text set to "Today's Date"
    And I should see "Purchase Order" text set to "the recorded purchase order number"
    And I set "Pay Date" to "Today's Date"
    And I should see the "Immediate Pay" checkbox is "unchecked"
    And I set "Payment Method Code" to "M - AP USE ONLY"
    And I click "Hide" on the "Invoice Info" tab


  When I click "Show" on the "Process Items" tab
    And I am in the "Items" section
    And I fill out the "Items" table with:
      | Item # | Quantity Invoiced |
      | 1      | 1                 |
      | 2      | 1                 |
      | 3      | 1                 |
      | 4      | 1                 |
      | 5      | 1                 |
    And I should see the "Items" table filled out with:
      | Item # |  Unit Cost |
      | 1      |  6.00      |
      | 2      |  5.50      |
      | 3      |  9.00      |
      | 4      |  12.50     |
      | 5      |  2.45      |
    And I click the "clear all tax" button
    And I click the "calculate" button
    And I am in the "Additional Charges" section
    And I record the "[Vendor Remit Amount]" amount
    And I click "Hide" on the "Process Items" tab


  When I click "Show" on the "Account Summary" tab
    And I click the "refresh account summary" button
    And I click "Hide" on the "Account Summary" tab


  When I click "Show" on the "1099 Classification" tab
    And I should see "Total" text set to "[Vendor Remit Amount]"
    And I click the "save" button
    And I should see the message "Document was successfully saved."
    And I record this "document" number in the document header
  Then I click the "Submit" button
    And I click the "yes" button


  Given I am logged in as "kfs-test-sys10"
    And I am on the "Main Menu" system tab
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I click the "approve" button
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I should see "Status" text set to "FINAL" in the document header
    And I should see "Payment Request Status" text set to "Department-Approved" in the document header
  When I close all extra browser windows

  #========================Test ACH/Check Payment Method========================
  Given I am on the "Central Admin" system tab
    And I am logged in as "kfs-test-sec36"
  When I click the "Payment Request" link
    And I am in the "Payment Request Initiation" tab
    And I set "Purchase Order #" to "the recorded purchase order number"
    And I set "Invoice Number" to "11223348"
    And I set "Invoice Date" to "Today's Date"
    And I set "Vendor Invoice Amount" to "100"
    And I click the "continue" button
    And I click the "Yes" button


  When I am in the "Document Overview" tab
    And I am in the "Payment Request Detail" section
    And I should see "Use Tax Indicator" text set to "No"
    And I click the "Collapse All" button


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I should see "Vendor #" text set to "18360-0"
    And I click "Hide" on the "Vendor" tab


  When I click "Show" on the "Invoice Info" tab
    And I should see "Invoice Number" text set to "11223348"
    And I should see "Invoice Date" text set to "Today's Date"
    And I should see "Purchase Order" text set to "the recorded purchase order number"
    And I set "Pay Date" to "Today's Date"
    And I check the "Immediate Pay" checkbox
    And I set "Payment Method Code" to "A - ACH/Check"
    And I click "Hide" on the "Invoice Info" tab


  When I click "Show" on the "Process Items" tab
    And I am in the "Items" section
    And I fill out the "Items" table with:
      | Item # | Quantity Invoiced |
      | 1      | 1                 |
      | 2      | 1                 |
      | 3      | 1                 |
      | 4      | 1                 |
      | 5      | 1                 |
    And I should see the "Items" table filled out with:
      | Item # |  Unit Cost |
      | 1      |  6.00      |
      | 2      |  5.50      |
      | 3      |  9.00      |
      | 4      |  12.50     |
      | 5      |  2.45      |
    And I click the "clear all tax" button
    And I click the "calculate" button
    And I am in the "Additional Charges" section
    And I record the "[Vendor Remit Amount]" amount
    And I click "Hide" on the "Process Items" tab


  When I click "Show" on the "Account Summary" tab
    And I click the "refresh account summary" button
    And I click "Hide" on the "Account Summary" tab


  When I click "Show" on the "1099 Classification" tab
    And I should see "Total" text set to "[Vendor Remit Amount]"
    And I click the "save" button
    And I should see the message "Document was successfully saved."
    And I record this "document" number in the document header
    And I record this "payment request" number in the document header
    And I record this "payment request document" number in the document header
  Then I click the "Submit" button
    And I click the "yes" button


  Given I am logged in as "kfs-test-sys10"
    And I am on the "Main Menu" system tab
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I click the "approve" button
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I should see "Status" text set to "FINAL" in the document header
    And I should see "Payment Request Status" text set to "Department-Approved" in the document header
  When I close all extra browser windows

  @Day1 @PA004-06
  Scenario: Create credit memo

  Given I am on the "Central Admin" system tab
    And I am logged in as "kfs-test-sec36"
  When I click the "Vendor Credit Memo" link
    And I am in the "Credit Memo Initiation" tab
    And I set "Credit Memo # from Vendor" to "55443322"
  # #PREQ recorded number from the A - ACH/Check payment method
    And I set "Payment Request #" to "the recorded payment request number"
    And I set "Credit Memo Date" to "Today's Date"
    And I set "Vendor Credit Memo Amount" to "10"
    And I click the "Continue" button
  # #Clicking Yes is needed if you are reusing the same Credit Memo #
    # And I click the "Yes" button
    And I should see "Status" text set to "SAVED" in the document header
    And I should see "Credit Memo Status" text set to "In Process" in the document header
    And I click the "Collapse All" button


  When I click "Show" on the "Document Overview" tab
    And I set "Explanation" to "PA1004"
    And I click "Hide" on the "Document Overview" tab


  When I click "Show" on the "Vendor" tab
    And I am in the "Vendor Address" section
    And I should see "Vendor #" text set to "18360-0"
    And I click "Hide" on the "Vendor" tab


  When I click "Show" on the "Credit Memo Info" tab
    And I should see "Payment Method Code" set to "A - ACH/Check"
    And I click "Hide" on the "Credit Memo Info" tab


  When I click "Show" on the "Process Items" tab
    And I am in the "Items" section
    And I fill out the "Items" table with:
      | Item # | CM Cty |
      | 1      | 1      |
      | 2      | 1      |
      | 3      | 1      |
      | 4      | 1      |
      | 5      | 1      |
    And I click the "calculate" button
    And I am in the "Additional Charges" section
    And I record the "Grand Total:" amount
    And I click "Hide" on the "Process Items" tab


  When I click "Show" on the "Account Summary" tab
    And I click the "refresh account summary" button
    And I click "Hide" on the "Account Summary" tab


  When I click "Show" on the "1099 Classification" tab
    And I should see "Total" text set to "Grand Total:"
    And I record this "document" number in the document header
    And I record this "vendor credit memo" number in the document header
    And I record this "vendor credit memo document" number in the document header


  When I click "Show" on the "Route Log" tab
    And I click the "submit" button
    And I click the "yes" button


  Given I am on the "Main Menu" system tab
  When I click the "document search" button
    And I set "Document/Notification Id" to "the recorded document number" on the search page
    And I click the "search" button
    And I open the saved document with "Document/Notification Id" of "the recorded document number"
  Then a new browser window appears
    And I should see "Status" text set to "FINAL" in the document header
    And I should see "Credit Memo Status" text set to "Complete" in the document header
  When I close all extra browser windows