Feature: Manage leads
  In order to keep track of leads
  A user
  wants manage leads

  Scenario: Creating a lead
    Given I am registered and logged in as annika
    And I am on the new lead page
    And I fill in "lead_first_name" with "Erich"
    And I fill in "lead_last_name" with "Feldmeier"
    When I press "lead_submit"
    Then I should be on the leads page
    And I should see "Erich Feldmeier"

  Scenario: Adding a comment
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And I am on the lead's page
    And I fill in "comment_text" with "This is a good lead"
    When I press "comment_submit"
    Then I should be on the lead page
    And I should see "This is a good lead"
    And a comment should have been created

  Scenario: Editing a lead
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And I am on the leads page
    And I follow "edit"
    And I fill in "lead_phone" with "999"
    When I press "lead_submit"
    Then I should be on the leads page
    And a lead should exist with phone: "999"

  Scenario: Filtering leads
    Given I am registered and logged in as annika
    And a lead exists with user: annika, status: "New", first_name: "Erich"
    And a lead exists with user: annika, status: "Rejected", first_name: "Markus"
    And I go to the leads page
    When I check "new"
    And I press "filter"
    Then I should see "Erich"
    And I should not see "Markus"

  Scenario: Adding a task to a lead
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And I am on the lead's page
    And I follow "add_task"
    And I fill in "task_name" with "Call to get offer details"
    And I select "As soon as possible" from "task_due_at"
    And I select "Call" from "task_category"
    When I press "task_submit"
    Then I should be on the lead's page
    And a task should have been created
    And I should see "Call to get offer details"

  Scenario: Marking a lead as completed
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And a task exists with asset: the lead, name: "Call to get offer details", user: annika
    And I am on the lead's page
    When I check "task_completed_by_id"
    And I press "task_submit"
    Then the task "Call to get offer details" should have been completed
    And I should be on the lead's page
    And I should not see "Call to get offer details"

  Scenario: Deleting a task
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And a task exists with asset: the lead, name: "Call to get offer details", user: annika
    And I am on the lead's page
    When I press "Delete Task"
    Then I should be on the lead's page
    And a task should not exist
    And I should not see "Call to get offer details"

  Scenario: Converting a lead to a new account
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the lead's page
    When I follow "convert"
    And I fill in "account_name" with "World Dating"
    And I press "convert"
    Then I should be on the account page
    And I should see "World Dating"
    And I should see "Erich"

  Scenario: Converting a lead to an existing account
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And a account: "careermee" exists with user: annika
    And I am on the lead's page
    When I follow "convert"
    And I fill in "account_name" with "CareerMee"
    And I press "convert"
    Then I should be on the account page
    And I should see "CareerMee"
    And I should see "Erich"
    And 1 accounts should exist