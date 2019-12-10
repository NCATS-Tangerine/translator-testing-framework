Feature:
    Scenario: normalize
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "DOID:4325", "type": "disease"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://robokop.renci.org:4868/normalize
        Then we expect a HTTP "200"
        And the response should have query_graph with a node with curie containing MONDO:0005737

    Scenario: yank
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737", "type": "disease"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        And knowledge graph
        """
        {
            "nodes": [
                {"id": "MONDO:0005737", "name": "Ebola hemorrhagic fever"},
                {"id": "HGNC:20818", "name": "LRRC15"},
                {"id": "HGNC:16361", "name": "WHRN"}
            ],
            "edges": [
                {"id": "xxx", "source_id": "MONDO:0005737", "target_id": "HGNC:20818"},
                {"id": "yyy", "source_id": "MONDO:0005737", "target_id": "HGNC:16361"}
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:20818"}
            ],
            "edge_bindings": []
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:16361"}
            ],
            "edge_bindings": []
        }
        """
        When the message is processed by http://robokop.renci.org:4868/yank
        Then we expect a HTTP "200"
        And the response should have knowledge_graph with a node with name WHRN

    Scenario: support
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737", "type": "disease"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        And knowledge graph
        """
        {
            "nodes": [
                {"id": "MONDO:0005737", "name": "Ebola hemorrhagic fever"},
                {"id": "HGNC:7897", "name": "NPC1"}
            ],
            "edges": [
                {"id": "xxx", "source_id": "MONDO:0005737", "target_id": "HGNC:7897"}
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:7897"}
            ],
            "edge_bindings": []
        }
        """
        When the message is processed by http://robokop.renci.org:4868/support
        Then we expect a HTTP "200"
        And the response should have knowledge_graph with an edge with type literature_co-occurrence

    Scenario: weight_correctness
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737", "type": "disease"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        And knowledge graph
        """
        {
            "nodes": [
                {"id": "MONDO:0005737", "name": "Ebola hemorrhagic fever"},
                {"id": "HGNC:7897", "name": "NPC1"}
            ],
            "edges": [
                {
                    "id": "xxx", "source_id": "MONDO:0005737", "target_id": "HGNC:7897",
                    "num_publications": 4, "type": "disease_to_gene_association"
                }
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:7897"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "xxx"}
            ]
        }
        """
        When the message is processed by http://robokop.renci.org:4868/weight_correctness
        Then we expect a HTTP "200"
        And the response should have a result with an edge_binding with weight

    Scenario: screen
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "DOID:4325", "type": "disease"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        And knowledge graph
        """
        {
            "nodes": [
                {"id": "MONDO:0005737", "name": "Ebola hemorrhagic fever"},
                {"id": "HGNC:7897", "name": "NPC1"}
            ],
            "edges": [
                {
                    "id": "xxx", "source_id": "MONDO:0005737", "target_id": "HGNC:7897",
                    "num_publications": 4, "type": "disease_to_gene_association"
                }
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:20818"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "xxx", "weight": 1}
            ],
            "score": 1
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:16361"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "yyy", "weight": 2}
            ],
            "score": 2
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:16361"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "yyy", "weight": 2}
            ],
            "score": 3
        }
        """
        And options
        """
        {
            "max_results": 2
        }
        """
        When the message is processed by http://robokop.renci.org:4868/screen
        Then we expect a HTTP "200"
        And the response should have 2 results

    Scenario: weight_novelty
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737", "type": "disease"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        And knowledge graph
        """
        {
            "nodes": [
                {"id": "MONDO:0005737", "name": "Ebola hemorrhagic fever"},
                {"id": "HGNC:7897", "name": "NPC1"}
            ],
            "edges": [
                {
                    "id": "xxx", "source_id": "MONDO:0005737", "target_id": "HGNC:7897"
                }
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:7897"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "xxx"}
            ]
        }
        """
        When the message is processed by http://robokop.renci.org:4868/weight_novelty
        Then we expect a HTTP "200"
        And the response should have a result with an edge_binding with weight

    Scenario: score
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        And knowledge graph
        """
        {
            "nodes": [
                {"id": "MONDO:0005737"},
                {"id": "HGNC:20818"},
                {"id": "HGNC:16361"}
            ],
            "edges": [
                {"id": "xxx", "source_id": "MONDO:0005737", "target_id": "HGNC:20818"},
                {"id": "yyy", "source_id": "MONDO:0005737", "target_id": "HGNC:16361"}
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:20818"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "xxx", "weight": 1}
            ]
        }
        """
        And a result
        """
        {
            "node_bindings": [
                {"qg_id": "n01", "kg_id": "MONDO:0005737"},
                {"qg_id": "n02", "kg_id": "HGNC:16361"}
            ],
            "edge_bindings": [
                {"qg_id": "e12", "kg_id": "yyy", "weight": 2}
            ]
        }
        """
        When the message is processed by http://robokop.renci.org:4868/score
        Then we expect a HTTP "200"
        And the response should have a result with a node_binding with kg_id HGNC:16361

    Scenario: answer
        Given query graph
        """
        {
            "nodes": [
                {"id": "n01", "curie": "MONDO:0005737"},
                {"id": "n02", "type": "gene"}
            ],
            "edges": [
                {"id": "e12", "source_id": "n01", "target_id": "n02"}
            ]
        }
        """
        When the message is processed by http://robokop.renci.org:4868/answer
        Then we expect a HTTP "200"
        And the response should have a result with score
