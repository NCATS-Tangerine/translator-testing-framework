Feature: Tests for the RTX reasoning tool

    Scenario: Fanconi anemia is associated with expected genes
        Given the "English" question "What genes are associated with Fanconi anemia?"
        When we send the question to RTX
        Then the results should contain the following nodes
            | id               | name   |
            | UniProtKB:P51587 | BRCA2  |
            | UniProtKB:O15360 | FANCA  |
            | UniProtKB:Q00597 | FANCC  |
            | UniProtKB:O15287 | FANCG  |

    Scenario: Malaria is associated with sickle cell anemia
        Given the "English" question "What diseases are similar to Malaria?"
        When we send the question to RTX
        Then the results should include a node with ID "OMIM:603903"

    Scenario: Acetaminophen targets PTGS1
        Given the "English" question "What are the drugs that target PTGS1?"
        When we send the question to RTX
        Then the results should include a node with ID "CHEMBL.COMPOUND:CHEMBL112"

    Scenario: Fanconi anemia has expected symptoms
        Given the "English" question "What are the symptoms of Fanconi anemia?"
        When we send the question to RTX
        Then the results should contain the following nodes
            | id         | name                    |
            | HP:0000978 | bruising susceptibility |
            | HP:0001510 | growth delay            |
            | HP:0000252 | microcephaly            |

    Scenario: Phenylalanine hydroxylase is in the phenylketonuria pathway
        Given the "English" question "What proteins are in the phenylketonuria pathway?"
        When we send the question to RTX
        Then the results should include a node with ID "UniProtKB:P00439"