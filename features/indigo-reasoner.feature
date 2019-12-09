Feature: Tests for the Indigo workflow reasoner
	
    Scenario: basic response
        Given "chemical substance" "ibuprofen" with ID "CHEMBL:CHEMBL521"
        When we query IndigoR for "protein targets"
        Then we expect a HTTP "200"
       	Then the response should contain "result_graph"
       	Then the response should have some JSONPath "context" with "string" "translator_indigo_qa"

    Scenario: targets of ibuprofen
        Given "chemical substance" "ibuprofen" with ID "CHEMBL:CHEMBL521"
        When we query IndigoR for "protein targets"
        Then the result graph contains the following nodes
            | id     | name                                  |
            | 566885 | arachidonate 5-lipoxygenase           |
            | 573981 | prostaglandin-endoperoxide synthase 1 |
