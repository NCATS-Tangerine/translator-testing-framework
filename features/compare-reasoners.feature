Feature: Compare answers between reasoners

    Scenario: Compare answers between RTX and ROBOKOP
        Given an answer graph from "RTX"
        Given an answer graph from "ROBOKOP"
        When we compare the answer graphs
        Then the response should contain "graph_diff"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].source_id" containing "string" "HP:0002105"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].relation" containing "string" "RO:0002200"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].relation_label" containing "string" "has phenotype"
        Then the response should have some JSONPath "graph_diff.intersection.edges[*].target_id" containing "string" "MONDO:0018076"
