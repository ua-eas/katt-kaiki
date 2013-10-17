# Description: This file contains arrays that contain feature file tag names that need
#              to be run in a certain order.
#
# Original Date: September 17, 2013



# Public: This jirra method defines the Array "array" which contains all of the tag names
#         for the feature files in the KC systems. It is structured this way because of the
#         order the features need to be run in.
#
# Returns nothing.

def jirra
  array = [
      ['@Proposal_New', '@Award_New', '@Proposal_Continuation', '@Award_Allotment', '@Award_Supplement_Continuation', '@Proposal_Revision', '@Proposal_Renewal'],
      ['@Proposal_New', '@Proposal_Resubmission'],
      ['@Proposal_New', '@Award_New', '@Award_Deobligation', '@Proposal_Admin_Change'],
      ['@Proposal_New', '@Award_New', '@Award_Admin_Amendment'],
      ['@Proposal_New', '@Award_New', '@Award_No_Cost_Extension'],
      ['@Proposal_New', '@Award_New', '@Award_Unlink_IP', '@Award_Supp_Cont_II']
    ]
end
