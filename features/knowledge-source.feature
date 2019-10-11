Feature: Check all knowledge sources

    Scenario: Check HMDB knowledge map
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        when we fire "/kmap" query
        then the response contains the following entries in "category" of "subject":
            | category    |
            | metabolite  |
        and the response only contains the following entries in "category" of "subject":
            | category    |
            | metabolite  |
        and the response contains the following entries in "relation" of "predicate":
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        and the response only contains the following entries in "relation" of "predicate":
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        and the response contains the following entries in "category" of "object":
            | category                   |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |
        and the response only contains the following entries in "category" of "object":
            | category                   |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |


    Scenario: Check HMDB categories
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        when we fire "/categories" query
        then the response contains the following entries in "category":
            | category                   |
            | metabolite                 |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |
        and the response only contains the following entries in "category":
            | category                   |
            | metabolite                 |
            | protein                    |
            | cellular component         |
            | gross anatomical structure |
            | pathway                    |
            | disease                    |


    Scenario: Check HMDB predicates
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        when we fire "/predicates" query
        then the response contains the following entries in "relation":
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        and the response only contains the following entries in "relation":
            | relation        |
            | interacts with  |
            | located in      |
            | participates in |
            | related to      |
        and the response contains the following entries in "edge_label":
            | edge_label        |
            | interacts_with  |
            | located_in      |
            | participates_in |
            | related_to      |
        and the response only contains the following entries in "edge_label":
            | edge_label        |
            | interacts_with  |
            | located_in      |
            | participates_in |
            | related_to      |


    Scenario: Check HMDB concepts
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        when we fire "/concepts?keywords=aspirin&categories=metabolite" query
        then the response contains "Aspirin" in "name"


    Scenario: Check HMDB exactmatches
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        when we fire "/exactmatches?c=CHEBI:15365" query
        then the size of the response is 1
        and the response should have some JSONPath "$[0].has_exact_matches[0]" with "string" "HMDB:HMDB0001879"


    Scenario: Check HMDB concept
        Given a knowledge source at "https://translator.ncats.io/hmdb-knowledge-beacon"
        when we fire "/concepts/HMDB:HMDB0001879" query
        then the response should have some JSONPath "id" with "string" "HMDB:HMDB0001879"
        then the response should have some JSONPath "name" with "string" "Aspirin"
