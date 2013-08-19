Feature: proposal creation and submission

  As a Central Administrator
  I want to be able to create and submit a basic proposal with the following attributes:
    Federal Sponsor, No Prime, PI/Co-I, 
    Credit Split = One Dept, Human Subjects, 
    Predominately 'No' Questions, 
    Direct/Indirect Budget, 5 Budget Periods,
    No Unrecovered F&A, No Cost Share, No Project
    Incoming, No Validation Warnings
  So that  the proposal moves through the workflow and ends in an "Approved and Submitted" status.

  Background:
    Given I am up top

  Scenario: create and submit basic proposal

  Given I am backdoored as "sandovar"
	  And I am on the "Central Admin" tab
  When I click the "Proposal Development" portal link
  Then I should see "Status" set to "In Progress" in the document header
	When I set the "Description" to "Garland, NIA, $500,000"
	  And I set the "Proposal Type" to "New"
	  And I set the "Lead Unit" to "0721"
	  And I set the "Activity Type" to "Research"
	  And I set the "Project Title" to something like "Test scenario: create and submit basic proposal"
	  And I set the "Sponsor Code" to "010803"
	Then I should see "National Institute on Aging" under the sponsor code
	When I set the "Project Start Date" to "02/01/2014"
	  And I set the "Project End Date" to "01/31/2019"
	  And I click "Show" on the "Sponsor & Program Information" tab
	  And I set "Sponsor Deadline Date" to "10/01/2013"
    And I set "NSF Science Code" to "F.03: Medical - Life Sciences"
    And I click the "Save" button  
	Then I should see the message "Document was successfully saved."
    And I should see "Sponsor Name" set to "National Institute on Aging" in the document header 
  When I am on the "Special Review" document tab
    And I set the field "Type" to "Human Subjects"
    And I set the field "Approval Status" to "Approved"
    And I click the "Add" button
    And I click the "Save" button
  Then I should see the message "Document was successfully saved."
  When I am on the "Custom Data" document tab
    And I click "Show" on the "Project Information" tab
    And I set Prj Location to "0211-0124-"
    And I set F&A Rate to "51.500"
    And I click the "Save" button 
  When I am on the "Questions" document tab
    And I click "Show" on the "Does the Proposed Work Include any of the Following?" tab
    And I answer the questions under "Does the Proposed Work Include any of the Following?" with:
          |  1     |  No    |
          |  2     | Yes    |
          |  3     |  No    |
          |  4     |  No    |
          |  5     |  No    |
          |  6     |  No    |
          |  7     |  No    |
          |  8     |  No    |
          |  9     |  No    |
          | 10     |  No    |
          | 11     | Yes    |
          | 12     |  No    |
          | 13     |  No    |
          | 14     |  No    |
          | 15     |  No    |
          | 16     |  No    |
          | 17     |  No    |
          | 18     |  No    |
    And I click "Hide" on the "Does the Proposed Work Include any of the Following?" tab
    And I click "Show" on the "F&A (Indirect Cost) Questions" tab
    And I answer the questions under "F&A (Indirect Cost) Questions" with:
          |  1 | No |
          |  2 | No |
          |  3 | No |
    And I click "Hide" on the "F&A (Indirect Cost) Questions" tab
    And I click "Show" on the "Grants.gov Questions" tab
    And I answer the questions under "Grants.gov Questions" with:
          |  1 |  No | 
          |  2 |  No | 
          |  3 |  No | 
          |  4 |  No | 
          |  5 |  No | 
          |  6 | N/A | 
          |  7 |  No | 
          |  8 |  No | 
          |  9 |  No | 
          | 10 |  No | 
          | 11 | N/A | 
          | 12 |  No | 
          | 13 |  No | 
    And I click "Hide" on the "Grants.gov Questions" tab
    And I click "Show" on the "PRS Questions" tab
    And I answer the questions under "PRS Questions" with:
          |  1 |  No | 
          |  2 |  No | 
          |  3 |  No | 
    And I click "Hide" on the "PRS Questions" tab
    And I click the "Save" button
  Then I should see the message "Document was successfully saved."
  When I am on the "Budget Versions" document tab
      And I enter "Final Budget" under "Name"
      And I click "Add"
      And I click "Open" on "Final Budget"
