Feature: Check all knowledge sources

    Scenario: Check HMDB knowledge map
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/kmap" query
        Then the response contains the following entries in "category" of "subject"
            | category    |
            | metabolite  |
        And the response only contains the following entries in "category" of "subject"
            | category    |
            | metabolite  |
        And the response contains the following entries in "relation" of "predicate"
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        And the response only contains the following entries in "relation" of "predicate"
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        And the response contains the following entries in "category" of "object"
            | category                   |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |
        And the response only contains the following entries in "category" of "object"
            | category                   |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |


    Scenario: Check HMDB categories
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/categories" query
        Then the response contains the following entries in "category"
            | category                   |
            | metabolite                 |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |
        And the response only contains the following entries in "category"
            | category                   |
            | metabolite                 |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |


    Scenario: Check HMDB predicates
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/predicates" query
        Then the response contains the following entries in "relation"
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        And the response only contains the following entries in "relation"
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        And the response contains the following entries in "edge_label"
            | edge_label      |
            | interacts_with  |
            | located_in      |
            | participates_in |
            | related_to      |
        And the response only contains the following entries in "edge_label"
            | edge_label      |
            | interacts_with  |
            | located_in      |
            | participates_in |
            | related_to      |


    Scenario: Check HMDB concepts
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/concepts?keywords=aspirin&categories=metabolite" query
        Then the response contains "Aspirin" in "name"


    Scenario: Check HMDB exactmatches
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/exactmatches?c=CHEBI:15365" query
        Then the size of the response is 1
        And the response should have some JSONPath "$[0].has_exact_matches[0]" with "string" "HMDB:HMDB0001879"


    Scenario: Check HMDB concept
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/concepts/HMDB:HMDB0001879" query
        Then the response should have some JSONPath "id" with "string" "HMDB:HMDB0001879"
        Then the response should have some JSONPath "name" with "string" "Aspirin"


    Scenario: Check HMDB statements
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/statements?s=HMDB:HMDB0001879" query
        Then the response only contains the following entries in "id" of "subject"
            | id               |
            | HMDB:HMDB0001879 |
        And the response only contains the following entries in "name" of "subject"
            | name    |
            | Aspirin |


    Scenario: Check HMDB statement
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        When we fire "/statements/2" query
        Then the response should have some JSONPath "id" with "string" "2"
        And the response should have some JSONPath "provided_by" with "string" "http://www.hmdb.ca/"
