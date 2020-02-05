Feature: Check mediKanren responses

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
