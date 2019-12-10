Feature: Check ROBOKOP ranker responses

    Scenario: Ebola Query produces NPC and Niemann-Pick Disease
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737", "type": "disease"},
                {"id": "n02", "type": "gene"},
                {"id": "n03", "type": "genetic_condition"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"},
                {"id": "e23", "source_id": "n02", "target_id": "n03"}
            ]
        }
        """
        When the message is processed by https://robokop.renci.org/ranker/api/query/
        Then we expect a HTTP "200"
        And the response should have an answer with node_bindings with n02 containing HGNC:7897
        And the response should have an answer with node_bindings with n03 containing MONDO:0001982

    Scenario: NAT2 related to tuberculosis
        Given query_graph
        """
        {
            "nodes": [
                {
                    "id": "n0",
                    "type": "disease",
                    "curie": [
                        "MONDO:0018076"
                    ],
                    "set": false
                },
                {
                    "id": "n1",
                    "type": "sequence_variant",
                    "set": false
                },
                {
                    "id": "n2",
                    "type": "gene",
                    "set": false
                },
                {
                    "id": "n3",
                    "type": "chemical_substance",
                    "set": false
                }
            ],
            "edges": [
                {
                    "id": "e0",
                    "source_id": "n0",
                    "target_id": "n1"
                },
                {
                    "id": "e1",
                    "source_id": "n1",
                    "target_id": "n2"
                },
                {
                    "type": [
                        "increases_degradation_of"
                    ],
                    "id": "e2",
                    "source_id": "n2",
                    "target_id": "n3"
                },
                {
                    "id": "e3",
                    "source_id": "n0",
                    "target_id": "n3"
                }
            ]
        }
        """
        When the message is processed by https://robokop.renci.org/ranker/api/query/
        Then we expect a HTTP "200"
        And the response should have an answer with node_bindings with n2 containing HGNC:7646

    Scenario: Genes relating degreasers to colitis
        Given query_graph
        """
        {
            "nodes": [
                {
                    "id": "n0",
                    "type": "chemical_substance",
                    "set": false,
                    "curie": [
                        "CHEBI:15347"
                    ]
                },
                {
                    "id": "n1",
                    "type": "chemical_substance",
                    "set": false,
                    "curie": [
                        "CHEBI:35290"
                    ]
                },
                {
                    "id": "n2",
                    "type": "chemical_substance",
                    "set": false,
                    "curie": [
                        "CHEBI:16602"
                    ]
                },
                {
                    "id": "n3",
                    "type": "gene",
                    "set": false
                },
                {
                    "id": "n4",
                    "type": "gene",
                    "set": false
                },
                {
                    "id": "n5",
                    "type": "gene",
                    "set": false
                },
                {
                    "id": "n6",
                    "type": "disease",
                    "set": false,
                    "curie": [
                        "MONDO:0005292"
                    ]
                },
                {
                    "id": "n7",
                    "type": "biological_process_or_activity",
                    "set": false
                }
            ],
            "edges": [
                {
                    "id": "e0",
                    "source_id": "n0",
                    "target_id": "n3"
                },
                {
                    "id": "e1",
                    "source_id": "n1",
                    "target_id": "n4"
                },
                {
                    "id": "e2",
                    "source_id": "n2",
                    "target_id": "n5"
                },
                {
                    "id": "e3",
                    "source_id": "n6",
                    "target_id": "n3"
                },
                {
                    "id": "e4",
                    "source_id": "n4",
                    "target_id": "n6"
                },
                {
                    "id": "e5",
                    "source_id": "n6",
                    "target_id": "n5"
                },
                {
                    "id": "e6",
                    "source_id": "n7",
                    "target_id": "n3"
                },
                {
                    "id": "e7",
                    "source_id": "n4",
                    "target_id": "n7"
                },
                {
                    "id": "e8",
                    "source_id": "n5",
                    "target_id": "n7"
                }
            ]
        }
        """
        When the message is processed by https://robokop.renci.org/ranker/api/query/
        Then we expect a HTTP "200"
        And the response should have an answer with node_bindings with n3 containing HGNC:1516
        And the response should have an answer with node_bindings with n4 containing HGNC:1516
        And the response should have an answer with node_bindings with n5 containing HGNC:11892

  Scenario: Mizolastine/Rhinitis COP finds HRH1, Mast cells
        Given query_graph
        """
        {
            "nodes": [
                {
                    "id": "n0",
                    "type": "chemical_substance",
                    "set": false,
                    "curie": [
                        "CHEBI:31857"
                    ]
                },
                {
                    "id": "n1",
                    "type": "gene",
                    "set": false
                },
                {
                    "id": "n2",
                    "type": "biological_process_or_activity",
                    "set": true
                },
                {
                    "id": "n3",
                    "type": "cell",
                    "set": false
                },
                {
                    "id": "n4",
                    "type": "anatomical_entity",
                    "set": false
                },
                {
                    "id": "n5",
                    "type": "phenotypic_feature",
                    "set": false,
                    "curie": [
                        "HP:0003193"
                    ]
                }
            ],
            "edges": [
                {
                    "id": "e0",
                    "source_id": "n0",
                    "target_id": "n1"
                },
                {
                    "id": "e1",
                    "source_id": "n1",
                    "target_id": "n2"
                },
                {
                    "id": "e2",
                    "source_id": "n2",
                    "target_id": "n3"
                },
                {
                    "id": "e3",
                    "source_id": "n3",
                    "target_id": "n4"
                },
                {
                    "id": "e4",
                    "source_id": "n4",
                    "target_id": "n5"
                }
            ]
        }
        """
        When the message is processed by https://robokop.renci.org/ranker/api/query/
        Then we expect a HTTP "200"
        And the response should have an answer with node_bindings with n1 containing HGNC:5182
        And the response should have an answer with node_bindings with n3 containing CL:0000097
