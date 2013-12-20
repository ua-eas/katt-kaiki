# Description: This file contains arrays that contain feature file tag names that need
#              to be run in a certain order.
#
# Original Date: September 17, 2013



# Public: This jirra method defines the Array "array" which contains all of the tag names
#         for the feature files in the KC systems. It is structured this way because of the
#         order the features need to be run in.
#
# Returns nothing.

def kc_tags
  array = [
      ['@Proposal_New', '@Award_New', '@Proposal_Continuation', '@Award_Allotment', '@Award_Supplement_Continuation', '@Proposal_Revision', '@Proposal_Renewal'],
      ['@Proposal_New', '@Proposal_Resubmission'],
      ['@Proposal_New', '@Award_New', '@Award_Deobligation', '@Proposal_Admin_Change'],
      ['@Proposal_New', '@Award_New', '@Award_Admin_Amendment'],
      ['@Proposal_New', '@Award_New', '@Award_No_Cost_Extension'],
      ['@Proposal_New', '@Award_New', '@Award_Unlink_IP', '@Award_Supp_Cont_II']
    ]
end

# Public: This method contains a hash of arrays. The keys in the hash are
#         "Day1", "Day2", etc., and refer to the tests that need to be run
#         on these respective days (usually with a batch run inbetween).
#         The inner arrays hold the tags for the KFS tests that will be run
#         in a particular order; each suite is in it's own array.
#
# Returns Nothing

def kfs_tags
  day_hash = {
    "Day1" => [
                ['@DV001-01'],
                ['@PVEN002.01'],
                ['@DI003-01'],
                ['@PRE001-01'],
                ['@TF001-01'],
                ['@COA002-01'],
                ['@SET001-01'],
                ['@PA004-01', '@PA004-02', '@PA004-0304', '@PA004-05', '@BAT001-01', '@PA004-06'],
                ['@BAT001-01']
    ],
    "Day2" => [
                ['@1099001-01'],
                ['@CASH001-01'],
                ['@PA004-07']
    ]
  }
end
