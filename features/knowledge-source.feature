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

