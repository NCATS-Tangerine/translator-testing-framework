Feature: Test TranQL's answer from a given TranQL query with an invalid transition

    Scenario: Test the answer when using terms that are not in the concept model
      Given the TranQL query:
      """
        SELECT foo->bar
        FROM "/schema"
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should have some JSONPath "message" with "string" "Concept "foo" is not in the concept model."
      Then the response should have some JSONPath "status" with "string" "Error"

    Scenario: Test the answer when using valid terms that have no supported transitions between each other.
      Given the TranQL query:
      """
        SELECT pathway->chemical_substance
        FROM "/schema"
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should have some JSONPath "message" with "string" "Invalid transition between pathway:[] and chemical_substance:[]"
      Then the response should have some JSONPath "status" with "string" "Error"
