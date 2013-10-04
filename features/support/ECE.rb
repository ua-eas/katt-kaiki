#Discription: Takes and finds files with --tags and runs them in order
# Original Date: September 17, 2013
#


#Public: Runs tests that need to be run in oder
#
# Parameters
#
# 1 @Proposal_New
# 2 @Award_New
# 3 @Proposal_Continuation
# 4 @Award_Allotment
# 5 @Award_Supplement_Continuation
# 6 @Proposal_Revision
# 7 @Proposal_Renewal
# 8 @Proposal_Resubmission
# 9 @Award_Deobligation
# 10 @Proposal_Admin_Change
# 11 @Award_Admin_Amendment
# 12 @Award_No_Cost_Extension
#
#
# Example
# Test 1 = @Proposal_New
#Returns Nothing

def jirra
  array = [
      #['@Proposal_New']
      ['@Proposal_New', '@Award_New', '@Proposal_Continuation', '@Award_Allotment', '@Award_Supplement_Continuation', '@Proposal_Revision', '@Proposal_Renewal'],
      #['@Proposal_New', '@Proposal_Resubmission'],
      ['@Proposal_New', '@Award_New', '@Award_Deobligation', '@Proposal_Admin_Change']
    ]
end
