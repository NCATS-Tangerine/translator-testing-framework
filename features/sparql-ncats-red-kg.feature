Feature: Test ncats-red-kg triplestore answers from given SPARQL queries to detect for issue in the transformation

  Scenario: Check for DrugBank drug name
    Given the dataset "https://w3id.org/data2services/graph/biolink/drugbank"
    When we get the entity "http://identifiers.org/drugbank:DB00001"
    Then its property "bl:name" should be "Lepirudin"
