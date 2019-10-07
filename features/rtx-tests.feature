Feature: Tests for the RTX reasoning tool

    Scenario: Fanconi anemia is associated with expected genes
        Given the "English" question "What genes are associated with Fanconi anemia?"
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id               | name   |
            | UniProtKB:P51587 | BRCA2  |
            | UniProtKB:O15360 | FANCA  |
            | UniProtKB:Q00597 | FANCC  |
            | UniProtKB:O15287 | FANCG  |

    Scenario: Malaria is associated with sickle cell anemia
        Given the "English" question "What diseases are similar to Malaria?"
        When we send the question to RTX
        Then the answer graph should include node "OMIM:603903 (sickle cell anemia)"

    Scenario: Acetaminophen targets PTGS1
        Given the "English" question "What are the drugs that target PTGS1?"
        When we send the question to RTX
        Then the answer graph should include node "CHEMBL.COMPOUND:CHEMBL112 (acetaminophen)"

    Scenario: Fanconi anemia has expected symptoms
        Given the "English" question "What are the symptoms of Fanconi anemia?"
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id         | name                    |
            | HP:0000978 | bruising susceptibility |
            | HP:0001510 | growth delay            |
            | HP:0000252 | microcephaly            |

    Scenario: PAH is in the phenylketonuria pathway
        Given the "English" question "What proteins are in the phenylketonuria pathway?"
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:P00439 (PAH)"

    Scenario: Naproxen/cyclooxygenase pathway checks
        Given the "English" question "What biological processes involve proteins targeted by naproxen?"
        When we send the question to RTX
        Then the results should include node "GO:0019371 (cyclooxygenase pathway)" with similarity value > 0.05
        And the answer graph should contain the following relationships
            | source_id        | name  | edge_type    | target_id  | name                   |
            | UniProtKB:P23219 | PTGS1 | involved_in  | GO:0019371 | cyclooxygenase pathway |
            | UniProtKB:P35354 | PTGS2 | involved_in  | GO:0019371 | cyclooxygenase pathway |

    Scenario: UROC1 participates in histidine catabolism
        Given the machine question
        """
        {
            "query_type_id": "Q63",
            "terms": {
                "protein": "UniProtKB:Q96N76"
            }
        }
        """
        When we send the question to RTX
        Then the answer graph should include node "REACT:R-HSA-6788656 (histidine catabolism)"

    Scenario: Adams-Oliver is associated with expected genes
        Given the "English" question "What genes are associated with Adams-Oliver syndrome?"
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id               | name     |
            | UniProtKB:Q2M1Z3 | ARHGAP31 |
            | UniProtKB:P60953 | CDC42    |
            | UniProtKB:Q96HP0 | DOCK6    |
            | UniProtKB:Q5NDL2 | EOGT     |
            | UniProtKB:P46531 | NOTCH1   |
            | UniProtKB:Q06330 | RBPJ     |
            | UniProtKB:Q9NR61 | DLL4     |