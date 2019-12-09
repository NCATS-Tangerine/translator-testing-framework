Feature: Tests for the Indigo reinforcement learning reasoner
	
	Scenario: basic response
		Given "chemical substance" "bivalirudin" with ID "185855"
        When we query RLR for "indications"
        Then we expect a HTTP "200"
       	Then the response should contain "nodes"
       	Then the response should contain "edges"

    Scenario: indications of bivalirudin
        Given "chemical substance" "bivalirudin" with ID "185855"
        When we query RLR for "indications"
        Then the answer graph contains the following nodes
            | id     | name                              |
            | 185855 | bivalirudin                       |
            | 625529 | Heparin-induced thrombocytopenia  |
            | 575003 | Thrombosis                        |
