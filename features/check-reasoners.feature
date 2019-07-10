Feature: Check all reasoners

    Scenario: Check for RTX reasoner
        Given a query graph "RTX"
        When we fire the query to "RTX" with URL "None" we expect a HTTP "200"
        Then the response should contain "knowledge_graph"
        Then the response should have some JSONPath "answers[*].node_bindings.n1" with "string" "HP:0002105"
        Then the response should have some JSONPath "answers[*].node_bindings.n3" with "string" "HGNC:11365"

   Scenario: Check for ROBOKOP reasoner
        Given a query graph "ROBOKOP"
        When we fire the query to "ROBOKOP" with URL "None" we expect a HTTP "200"
        Then the response should contain "knowledge_graph"
        Then the response should have some JSONPath "knowledge_graph.nodes[*].id" with "string" "HP:0002105"
        Then the response should have some JSONPath "knowledge_graph.nodes[*].type" with "string" "phenotypic_feature"


    Scenario: Check with actual query
        Given a query graph "ROBOKOP"
        When we fire an actual query to "ROBOKOP" with URL "https://robokop.renci.org/api/simple/quick/" we expect a HTTP "200"
        Then the response should contain "knowledge_graph"
        Then the response should have some node with id "CHEBI:66919" and field "therapeutic_flag" with value "True"
