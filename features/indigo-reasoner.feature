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
        Then the result graph (v0.9) contains the following nodes
            | id             | name                                  |
            | UNIPROT:P09917 | arachidonate 5-lipoxygenase           |
            | UNIPROT:P23219 | prostaglandin-endoperoxide synthase 1 |

    Scenario: indications of ibuprofen
        Given "chemical substance" "ibuprofen" with ID "CHEMBL:CHEMBL521"
        When we query IndigoR for "indications"
        Then the result graph (v0.9) contains the following nodes
            | id         | name  |
            | HP:0012531 | Pain  |
            | HP:0001945 | Fever |

    Scenario: symptoms associated with asthma
        Given "condition" "Asthma" with ID "UMLS:C0004096"
        When we query IndigoR for "associated symptoms"
        Then the result graph (v0.9) contains the following nodes
            | id         | name                 |
            | HP:0100785 | Sleeplessness        |
            | HP:0002098 | Respiratory distress |

    Scenario: conditions associated with respiratory distress
        Given "symptom" "Respiratory distress" with ID "UMLS:C0476273"
        When we query IndigoR for "associated conditions"
        Then the result graph (v0.9) contains the following nodes
            | id            | name               |
            | UMLS:C0001883 | Airway Obstruction |
            | UMLS:C0004096 | Asthma             |
            | UMLS:C0006271 | Bronchiolitis      |
