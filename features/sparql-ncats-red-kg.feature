Feature: Test ncats-red-kg triplestore answers from given SPARQL queries to detect for issue in the transformation

  Scenario: Check for DrugBank drug name
    Given the entity "http://identifiers.org/drugbank:DB00001" in the dataset "https://w3id.org/data2services/graph/biolink/drugbank"
    When we ask for the property "bl:name"
    Then we get the answer "Lepirudin"

  Scenario: Check for DrugBank drug ID using a SPARQL query
    Given the sparql endpoint "http://graphdb.dumontierlab.com/repositories/ncats-red-kg"
    When we run the sparql query:
    """
      SELECT * WHERE {
          GRAPH <https://w3id.org/data2services/graph/biolink/drugbank> {
              <http://identifiers.org/drugbank:DB00001> bl:id ?id .
          }
      }
    """
    Then the sparql result "id" should be "DB00001"
