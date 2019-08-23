Feature: Check ROBOKOP quick responses

    Scenario: Ebola Query produces Niemann-Pick Disease
        Given a question "genetic condition providing disease resistance" 
        And node mappings
        """
        {"input_disease":"MONDO:0005737"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/" 
        Then we expect a HTTP "200"
        Then the response should have some JSONPath "answers[0].node_bindings.n2" with "string" "MONDO:0001982"

