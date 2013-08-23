#
# Description: This file acts as the options menu when running cucumber features.
#              Each option provides a different function when you run the 
#              feature from a terminal window.
#
# Original Date: August 20, 2011
#

# Public: These options run when you run the command.
#         1) Opens the Cucumber book
#         2) Runs cucumber command
#         3) Displays undefined steps
#         4) Run all cucumber tests, except for the cucumber examples
#         5) Run a specific KFSI feature file (eg cuke_runner.sh 5 1021)
#         6) Run a specific KFSI feature file (eg cuke_runner.sh 6 1021)
#         7) Runs KC test scenario one
function usage {
  echo "Various cucumber commands:"
  echo ""
  echo "1. xdg-open ~/Documents/the-cucumber-book_b6_0.pdf"
  echo "      This command opens the cucumber book (Beta 6)"
  echo ""
  echo "2. cucumber"
  echo "      Base cucumber command"
  echo ""
  echo "3. cucumber --dry-run"
  echo "      Display undefined steps"
  echo ""
  echo "4. cucumber --tags ~@cucumber_example --tags ~@incomplete --tags ~@not_a_test"
  echo "      Run all cucumber tests, except for the cucumber examples"
  echo ""
  echo "5. cucumber features/login.feature -r features"
  echo "      Run a specific KFSI feature file (eg cuke_runner.sh 5 1021)"
  echo ""
  echo "6. cucumber features/login.feature -s -r features"
  echo "      Run a specific KFSI feature file (eg cuke_runner.sh 6 1021)"
  echo ""
  echo "7. cucumber features/create_and_submit_proposal_basic.feature"
  echo "      Run a KC feature file (eg cuke_runner.sh 7 )"
}

if [[ $1 = "" ]]; then
  usage
  exit 1
fi

command=$1; shift
test_suite=$2; shift

case $command in
1)
  echo xdg-open ~/Documents/the-cucumber-book_b6_0.pdf
  xdg-open ~/Documents/the-cucumber-book_b6_0.pdf
  ;;
2)
  echo cucumber
  cucumber
  ;;
3)
  echo cucumber --dry-run
  cucumber --dry-run
  ;;
4)
  echo cucumber --tags ~@cucumber_example --tags ~@incomplete --tags ~@not_a_test $@
  cucumber --tags ~@cucumber_example --tags ~@incomplete --tags ~@not_a_test $@
  ;;
5)
  jira=$1; shift
  echo cucumber features/${jira}.feature -r features $@
  cucumber features/${jira}.feature -r features $@
  ;;
6)
  jira=$1; shift
  echo cucumber features/${jira}.feature -s -r features $@
  cucumber features/${jira}.feature -s -r features $@
  ;;
7)
  echo cucumber features/create_and_submit_proposal_basic.feature
  cucumber features/create_and_submit_proposal_basic.feature
  ;;
*)
  usage
  exit 1
  ;;
esac
