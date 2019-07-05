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
      Then the response should have some JSONPath "knowledge_graph.edges[*].type[*]" with "string" "contraindicated_for"

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
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "chemical_substance"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "disease"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "genetic_condition"
      Then the response should have some JSONPath "knowledge_graph.edges[*].type[*]" with "string" "prevents"

    Scenario: Test TranQL's answer when querying only ICEES
      Given the TranQL query:
      """
        SELECT population_of_individual_organisms->chemical_substance
          FROM "/clinical/cohort/disease_to_chemical_exposure"
         WHERE icees.table = 'patient'
           AND icees.year = 2010
           AND icees.cohort_features.AgeStudyStart = '0-2'
           AND icees.feature.EstResidentialDensity < 1
           AND icees.maximum_p_value = 1
           AND drug_exposure !=~ '^(SCTID.*|rxcui.*|CAS.*|SMILES.*|umlscui.*)$'
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should contain "knowledge_graph"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].name" with "string" "cohort"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "population_of_individual_organisms"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "chemical_substance"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "drug"
      Then the response should have some JSONPath "knowledge_graph.edges[*].type[*]" with "string" "association"

    Scenario: Test TranQL's answer when querying all reasoners (including ICEES)
      Given the TranQL query:
      """
        SELECT population_of_individual_organisms->chemical_substance->gene->biological_process_or_activity<-phenotypic_feature
          FROM "/schema"
         WHERE icees.table = 'patient'
           AND icees.year = 2010
           AND icees.cohort_features.AgeStudyStart = '0-2'
           AND icees.feature.EstResidentialDensity < 1
           AND icees.maximum_p_value = 1
           AND drug_exposure !=~ '^(SCTID.*|rxcui.*|CAS.*|SMILES.*|umlscui.*)$'
      """
      When we fire the query to TranQL we expect a HTTP "200"
      Then the response should contain "knowledge_graph"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].name" with "string" "cohort"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "population_of_individual_organisms"
      Then the response should have some JSONPath "knowledge_graph.nodes[*].type[*]" with "string" "disease"
      Then the response should have some JSONPath "knowledge_graph.edges[*].type[*]" with "string" "association"
      Then the response should have some JSONPath "knowledge_graph.edges[*].type[*]" with "string" "interacts_with"
