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
                {"id": "e12", "type": "treats",           "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://localhost:8000/query
        Then we expect a HTTP "200"
        And the response should have some result that binds node n01 to UMLS:C0022237
