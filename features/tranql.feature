Feature: Test TranQL's answer from a given TranQL query

    Scenario:
      Given the TranQL query:
      """
        set chemical = "CHEMBL:CHEMBL3"
        SELECT chemical_substance->disease
        FROM "/graph/rtx"
        WHERE chemical_substance=$chemical
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should contain "knowledge_graph"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].id" with "string" "DOID:12918"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "chemical_substance"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "disease"
