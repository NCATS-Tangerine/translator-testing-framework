Feature: Tests for the RTX reasoning tool

    Scenario: Fanconi anemia gene search produces BRCA2
        Given the "English" question "What genes are associated with Fanconi anemia?"
        When we send the question to RTX
        Then the results should include a node with ID "UniProtKB:P51587"

    Scenario: Fanconi anemia search produces several known associated genes
        Given the "English" question "What genes are associated with Fanconi anemia?"
        When we send the question to RTX
        Then the results should contain the following nodes
            | id               | name   |
            | UniProtKB:P51587 | BRCA2  |
            | UniProtKB:O15360 | FANCA  |
            | UniProtKB:Q00597 | FANCC  |
            | UniProtKB:O15287 | FANCG  |

    Scenario: Symptoms of fanconi anemia checks
        Given the "English" question "What are the symptoms of Fanconi anemia?"
        When we send the question to RTX
        Then the results should contain the following relationships
            | source_id  | name           | edge_type     | target_id  | name                    |
            | DOID:13636 | fanconi anemia | has_phenotype | HP:0000978 | bruising susceptibility |
            | DOID:13636 | fanconi anemia | has_phenotype | HP:0001510 | growth delay            |
            | DOID:13636 | fanconi anemia | has_phenotype | HP:0000252 | microcephaly            |

    Scenario: PTGS1 physically interacts with acetaminophen
        Given the machine question
        """
        {
            "query_type_id": "Q3",
            "terms": {
                "chemical_substance": "CHEMBL.COMPOUND:CHEMBL112",
                "rel_type": "physically_interacts_with",
                "target_label": "protein"
            }
        }
        """
        When we send the question to RTX
        Then the results should show that "UniProtKB:P23219" "physically_interacts_with" "CHEMBL.COMPOUND:CHEMBL112"