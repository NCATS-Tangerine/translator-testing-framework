Feature: Check RTX responses
    # This feature asks the RTX knowledge graph various questions and verifies that its answers include expected
    # results. The tests query RTX using natural language questions, query graphs, or predefined query types.

    # NOTE: For tables, the 'name' column is always optional (it is ignored in the step implementations; it is simply
    # there for readability in this file)

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

    Scenario: Kawasaki disease has expected symptoms
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type     | target_curie | target_type        |
            | DOID:13378   | disease     | has_phenotype |              | phenotypic_feature |
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id         | name            |
            | HP:0001945 | fever           |
            | HP:0003116 | abnormal EKG    |
            | HP:0000988 | skin rash       |
            | HP:0002716 | lymphadenopathy |

    Scenario: Kawasaki disease is associated with expected genes
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type                      | target_curie | target_type |
            |              | protein     | gene_associated_with_condition | DOID:13378   | disease     |
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id               | name     |
            | UniProtKB:P12318 | FCGR2A   |
            | UniProtKB:Q96DU7 | ITPKC    |

    Scenario: TNFRSF11B binds TNFRSF11A
        Given a query graph with the following mappings
            | source_curie     | source_type | edge_type                 | target_curie | target_type |
            | UniProtKB:O00300 | protein     | physically_interacts_with |              | protein     |
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:Q9Y6Q6 (TNFRSF11A)"

    Scenario: TNFRSF11A/TNFRSF11B similarity check
        Given the "English" question "What proteins involve similar biological processes as TNFRSF11A?"
        When we send the question to RTX
        Then the results should include node "UniProtKB:O00300 (TNFRSF11B)" with similarity value > 0.2

    Scenario: Congenital diaphragmatic hernia is associated with GATA4
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type                      | target_curie | target_type |
            |              | protein     | gene_associated_with_condition |  DOID:3827   | disease     |
        When we send the question to RTX
        Then the answer graph should include node "DOID:3827 (GATA4)"

    Scenario: Ehlers-Danlos has subtypes I and III
        Given a query graph with the following mappings
            | source_curie  | source_type | edge_type   | target_curie | target_type |
            |               | disease     | subclass_of | DOID:13359   | disease     |
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id         | name         |
            | DOID:14757 | type III EDS |
            | DOID:14720 | type I EDS   |

    Scenario: Smith-Kingsmore has expected symptoms
        Given a query graph with the following mappings
            | source_curie  | source_type | edge_type     | target_curie | target_type        |
            | OMIM:616638   | disease     | has_phenotype |              | phenotypic_feature |
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id         | name                    |
            | HP:0000256 | macrocephaly            |
            | HP:0001249 | intellectual disability |
            | HP:0001250 | seizures                |

    Scenario: Smith-Kingsmore is caused by MTOR mutation
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type                    | target_curie | target_type |
            |              | protein     | gene_mutations_contribute_to | OMIM:616638  | disease     |
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:P42345 (MTOR)"

    Scenario: AKT1 regulates MTOR
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type | target_curie     | target_type |
            |              | protein     | regulates | UniProtKB:P42345 | protein     |
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:P31749 (AKT1)"

    Scenario: TSC1 mutation causes Tuberous Sclerosis Complex
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type                    | target_curie | target_type |
            |              | protein     | gene_mutations_contribute_to | OMIM:191100  | disease     |
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:Q92574 (TSC1)"

    Scenario: SLC16A11 is expressed in expected cellular components/anatomical entities
        Given a query graph with the following mappings
            | source_curie     | source_type | edge_type    | target_curie | target_type        |
            | UniProtKB:Q8NCK7 | protein     | expressed_in |              |                    |
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id             | name                           |
            | GO:0005886     | plasma membrane                |
            | GO:0005789     | endoplasmic reticulum membrane |
            | UBERON:0002107 | liver                          |

    Scenario: Expected drugs treat atrial fibrillation
        Given a query graph with the following mappings
            | source_curie | source_type        | edge_type     | target_curie | target_type |
            |              | chemical_substance | indicated_for | DOID:0060224 | disease     |
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id                         | name        |
            | CHEMBL.COMPOUND:CHEMBL1751 | digoxin     |
            | CHEMBL.COMPOUND:CHEMBL27   | propranolol |
            | CHEMBL.COMPOUND:CHEMBL1294 | quinidine   |

    Scenario: Carbetocin physically interacts with oxytocin receptor
        Given a query graph with the following mappings
            | source_curie                  | source_type        | edge_type                 | target_curie | target_type |
            | CHEMBL.COMPOUND:CHEMBL3301668 | chemical_substance | physically_interacts_with |              | protein     |
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:P30559 (OXTR)"

    Scenario: MIR1225 associated with polycystic kidney disease
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type                      | target_curie | target_type |
            |              | microRNA    | gene_associated_with_condition | OMIM:263200  | disease     |
        When we send the question to RTX
        Then the answer graph should include node "NCBIGene:100188847 (MIR1225)"

    Scenario: Ectodysplasin A associated with hypohidrotic ectodermal dysplasia
        Given a query graph with the following mappings
            | source_curie | source_type | edge_type                      | target_curie | target_type |
            |              | protein     | gene_associated_with_condition | DOID:14793   | disease     |
        When we send the question to RTX
        Then the answer graph should include node "UniProtKB:Q92838 (EDA)"

    Scenario: Metabolite PGG2 physically interacts with Protein PTGS1
        Given a query graph with the following mappings
            | source_curie     | source_type | edge_type                 | target_curie | target_type |
            | UniProtKB:P23219 | protein     | physically_interacts_with |              | metabolite  |
        When we send the question to RTX
        Then the answer graph should include node "KEGG:C05956 (Prostaglandin G2)"
    
    Scenario: Ileum is associated with nitric oxide
        Given the "English" question "What anatomy are associated with nitric oxide?"
        When we send the question to RTX
        Then the answer graph should contain the following nodes
            | id               | name                   |
            | UniProtKB:P47989 | xanthine dehydrogenase |
            | UBERON:0002116   | ileum                  |
    
    Scenario: AKT serine/threonine kinase 1 participates in Phenylketonuria pathway
        Given the machine question
        """
        {
            "query_type_id": "Q63",
            "terms": {
                "protein": "UniProtKB:P31749"
            }
        }
        """
        When we send the question to RTX
        Then the answer graph should include node "REACT:R-HSA-2160456 (Phenylketonuria)"