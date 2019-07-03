Feature: Test TranQL's answer from a given TranQL query that uses specific reasoners

    Scenario: Test TranQL's answer when querying only RTX
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

    Scenario: Test TranQL's answer when querying only Indigo
      Given the TranQL query:
      """
        set chemical = "CHEMBL:CHEMBL3"
        SELECT chemical_substance->disease
        FROM "/graph/indigo"
        WHERE chemical_substance=$chemical
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should contain "knowledge_graph"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].name" with "string" "(S)-nicotine"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "Drug"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "Disease"

    Scenario: Test TranQL's answer when querying only Gamma
      Given the TranQL query:
      """
        set chemical = "CHEMBL:CHEMBL3"
        SELECT chemical_substance->disease
        FROM "/graph/gamma/quick"
        WHERE chemical_substance=$chemical
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should contain "knowledge_graph"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].name" with "string" "(S)-nicotine"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "Drug"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "Disease"
