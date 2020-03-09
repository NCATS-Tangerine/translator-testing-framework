Feature: Check mediKanren responses

    # Determine if Imatinib might alleviate Asthma by down-regulating an unknown gene associated with Asthma.
    #
    # Imatinib (UMLS:C0935989) --negatively_regulates--> [gene X]
    # [gene X] --gene_associated_with_condition--> Asthma (UMLS:C0004096)
    #
    # Expect VEGFA (UMLS:C1823619) as a possible X.
    Scenario: Imatinib Asthma Query finds VEGFA Gene
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "UMLS:C0935989"},
                {"id": "n02", "type": "gene"},
                {"id": "n03", "curie": "UMLS:C0004096"}
            ],
            "edges": [
                {"id": "e12", "type": "negatively_regulates",           "source_id": "n01", "target_id": "n02"},
                {"id": "e23", "type": "gene_associated_with_condition", "source_id": "n02", "target_id": "n03"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n02 to UMLS:C1823619

    # Find a safe chemical to treat Nausea.
    #
    # [chemical_substance X] --treats--> Nausea (UMLS:C0027497)
    #
    # Expect Isopropyl Alcohol (UMLS:C0022237) as a possible X.
    Scenario: Nausea Query finds Isopropyl Alcohol
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "type": "chemical_substance"},
                {"id": "n02", "curie": "UMLS:C0027497"}
            ],
            "edges": [
                {"id": "e12", "type": "treats", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n01 to UMLS:C0022237

    # Find a chemical substance that negatively regulates the calcium-sensitive potassium channel KCNN3.
    #
    # [chemical_substance X] --negatively_regulates--> KCNN3 gene (UMLS:C141660)
    #
    # Expect the drug Fluoxetine (UMLS:C0016365) as a possible X.
    Scenario: KCNN3 gene Query finds Fluoxetine/Prozac as Drug Inhibitor
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "type": "chemical_substance"},
                {"id": "n02", "curie": "UMLS:C1416610"}
            ],
            "edges": [
                {"id": "e12", "type": "negatively_regulates", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n01 to UMLS:C0016365

    # Explore the molecular link between Aspirin and ulcer formation.
    # First, determine the set of biological entities X
    # that are down-regulated by the drug Aspirin.
    # Next, determine if those genes(s) and/or protein(s)
    # are causally linked to ulcer (UMLS:C0041582) formation.
    #
    # Aspirin (UMLS:C0004057) --negatively_regulates--> [biological_entity X] --prevents--> ulcers (UMLS:C0041582)
    #
    # Expect the biological entity mucins (UMLS:C0026682) as a possible X.
    Scenario: Aspirin Query finds negative regulation of mucins as a molecular mechanisms of ulcer formation
        Given query_graph
        """
         {
            "nodes": [
                {"id": "n01", "curie": "UMLS:C0004057"},
                {"id": "n02", "type":  "biological_entity"},
                {"id": "n03", "curie": "UMLS:C0041582"}
            ],
            "edges": [
                {"id": "e12", "type": "negatively_regulates", "source_id": "n01", "target_id": "n02"},
                {"id": "e23", "type": "prevents",             "source_id": "n02", "target_id": "n03"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n02 to UMLS:C0026682

    # Determine which diseases X cause heart failure.
    #
    # [disease_or_phenotypic_feature X] --causes--> Heart Failure (UMLS:C0018801)
    #
    # Expect Chagas Disease (UMLS:C0041234) as a possible X.
    Scenario: Heart Failure Query finds Chagas disease as a potential cause
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "type": "disease_or_phenotypic_feature"},
                {"id": "n02", "curie": "UMLS:C0018801"}
            ],
            "edges": [
                {"id": "e12", "type": "causes", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n01 to UMLS:C0041234

    # Find possible dangerous side-effects of taking Tylenol.
    #
    # Tylenol (UMLS:C0699142) --causes--> [disease_or_phenotypic_feature X]
    #
    # Expect Acute Liver Failure (UMLS:C0162557) as a possible X.
    Scenario: Tylenol Query finds acute liver failure as a side-effect
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "UMLS:C0699142"},
                {"id": "n02", "type": "disease_or_phenotypic_feature"}
            ],
            "edges": [
                {"id": "e12", "type": "causes", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n02 to UMLS:C0162557

    # Find genes upregulated by Morphine which are also associated with constipation.
    #
    # Morphine (CHEBI:17303) --increases_activity_of--> [gene X]
    # Constipation (MONDO:0002203) --disease_to_gene_association--> [gene X]
    #
    # Expect the gene OPRM1 (HGNC:8156) as a possible X.
    Scenario: Morphine Query finds upregulation of genes that have an association with constipation
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01a", "curie": "CHEBI:17303"},
                {"id": "n01b", "curie": "MONDO:0002203"},
                {"id": "n02", "type": "(\"named_thing\" \"gene\")"}
            ],
            "edges": [
                {"id": "e1a2", "type": "increases_activity_of",       "source_id": "n01a", "target_id": "n02"},
                {"id": "e1b2", "type": "disease_to_gene_association", "source_id": "n01b", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n02 to HGNC:8156

    # Find possible dangerous side-effects of taking the antibiotic Vancomycin.
    #
    # Vancomycin (UMLS:C0042313) --causes--> [disease_or_phenotypic_feature X]
    #
    # Expect Nephrotoxicity (UMLS:C0599918) as a possible X.
    Scenario: Antibiotic Vancomycin Query finds Nephrotoxicity as a side-effect
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "UMLS:C0042313"},
                {"id": "n02", "type": "disease_or_phenotypic_feature"}
            ],
            "edges": [
                {"id": "e12", "type": "causes", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n02 to UMLS:C0599918

    # Determine if a chemical substance increases molecular interactions
    # with the TLR4 gene.
    #
    # [chemical_substance X] --increases_molecular_interaction--> TLR4 gene (HGNC:11850)
    #
    # Expect lipopolysacharride (CHEBI:16412) as a possible X.
    Scenario: TLR4 gene Query returns potential interaction with bacterial lipopolysaccharide
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "type": "(\"named_thing\" \"chemical_substance\")"},
                {"id": "n02", "curie": "HGNC:11850"}
            ],
            "edges": [
                {"id": "e12", "type": "increases_molecular_interaction", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n01 to CHEBI:16412

    # Determine the biological entities that link the DNA-repair gene ATM to the
    # expression of the gene ACE2, a critical molecular regulator of blood pressure.
    # First, determine the a set of biological entities X that the ATM gene positively
    # regulates.  Next, determine if a biological entity X modulates positively
    # regulates expression of the ACE2 gene.
    #
    # ATM gene (UMLS:C0919524) --positively_regulates--> [biological_entity X]
    # [biological_entity X] --positively_regulates--> ACE2 gene (UMLS:C1422064)
    #
    # Expect Angiotensin II (UMLS:C0003009) as a possible biological entity X.
    Scenario: ATM gene is found to upregulate expression of the protein angiotensin II. Angiotensin II, in turn, is found to upregulates expression of the ACE2 gene.
        Given query_graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "UMLS:C0919524"},
                {"id": "n02", "type": "biological_entity"},
                {"id": "n03", "curie": "UMLS:C1422064"}
            ],
            "edges": [
                {"id": "e12", "type": "positively_regulates", "source_id": "n01", "target_id": "n02"},
                {"id": "e23", "type": "positively_regulates", "source_id": "n02", "target_id": "n03"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n02 to UMLS:C0003009
