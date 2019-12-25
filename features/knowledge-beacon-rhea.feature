Feature: Check Rhea Knowledge Beacon

    Scenario: Check Rhea Beacon categories
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/categories" query
        Then the response entries contain the following entries in the field "category"
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        And the response only contains the following entries in "category"
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |

    Scenario: Check Rhea Beacon predicates
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/predicates" query
        Then the response entries contain the following entries in the field "relation"
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        And the response only contains the following entries in "relation"
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        And the response entries contain the following entries in the field "edge_label"
            | edge_label                 |
            | molecularly_interacts_with |
            | derives_into               |
            | increases_synthesis_of     |
            | increases_degradation_of   |
            | participates_in            |
            | increases_activity_of      |
            | related_to                 |
        And the response only contains the following entries in "edge_label"
            | edge_label                 |
            | molecularly_interacts_with |
            | derives_into               |
            | increases_synthesis_of     |
            | increases_degradation_of   |
            | participates_in            |
            | increases_activity_of      |
            | related_to                 |

    Scenario: Check Rhea Beacon Name Space
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/namespaces" query
        Then the response entries contain the following entries in the field "local_prefix"
            | local_prefix |
            | RHEA         |
        And the response only contains the following entries in "local_prefix"
            | local_prefix |
            | RHEA         |


    Scenario: Check Rhea Beacon Knowledge Map
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/kmap" query
        Then the response contains the following entries in "category" of "subject"
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        And the response only contains the following entries in "category" of "subject"
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        And the response contains the following entries in "relation" of "predicate"
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        And the response only contains the following entries in "relation" of "predicate"
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        And the response contains the following entries in "edge_label" of "predicate"
            | edge_label                 |
            | molecularly_interacts_with |
            | derives_into               |
            | increases_synthesis_of     |
            | increases_degradation_of   |
            | participates_in            |
            | increases_activity_of      |
            | related_to                 |
        And the response only contains the following entries in "edge_label" of "predicate"
            | edge_label                 |
            | molecularly_interacts_with |
            | derives_into               |
            | increases_synthesis_of     |
            | increases_degradation_of   |
            | participates_in            |
            | increases_activity_of      |
            | related_to                 |
        And the response contains the following entries in "category" of "object"
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        And the response only contains the following entries in "category" of "object"
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |

    Scenario: Check keyword query of Rhea Beacon concepts
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/concepts?keywords=aspirin&categories=protein" query
        Then some entry in the response contains "Acetylsalicylate deacetylase." in field "name"

    # Rhea doesn't really support exactmatches?
    #Scenario: Check Rhea Beacon exactmatches
    #    Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
    #    When we fire "/exactmatches?c=EC%3A3.1.1.55" query
    #    Then the size of the response is 1
    #    And the response should have some JSONPath "$[0].has_exact_matches[0]" with "string" ""

    Scenario: Check one particular Rhea Beacon concept
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/concepts/EC%3A3.1.1.55" query
        Then the response should have a field "id" with "string" "EC:3.1.1.55"
        Then the response should have a field "name" with "string" "Acetylsalicylate deacetylase."
        Then the response should have a field "uri" with "string" "https://enzyme.expasy.org/EC/3.1.1.55"

    Scenario: Check Rhea Beacon statements
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        When we fire "/statements?s=EC%3A3.1.1.55" query
        Then the response only contains the following entries in "id" of "subject"
            | id          |
            | EC:3.1.1.55 |
        And the response only contains the following entries in "name" of "subject"
            | name                         |
            | Acetylsalicylate deacetylase.|
        And the response only contains the following entries in "edge_label" of "predicate"
            | edge_label               |
            | increases_synthesis_of   |
            | increases_degradation_of |
            | increases_activity_of    |
        And the response only contains the following entries in "id" of "object"
            | id          |
            | CHEBI:30762 |
            | CHEBI:15378 |
            | CHEBI:30089 |
            | CHEBI:15377 |
            | CHEBI:13719 |
            | RHEA:11752  |
