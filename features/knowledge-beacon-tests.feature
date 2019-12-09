Feature: Check Rhea Knowledge beacons

    Scenario: Check Rhea Beacon categories
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        when we fire "/categories" query
        then the response contains the following entries in "category":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response only contains the following entries in "category":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |

    Scenario: Check Rhea Beacon predicates
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        when we fire "/predicates" query
        then the response contains the following entries in "relation":
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        and the response only contains the following entries in "relation":
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        and the response contains the following entries in "edge_label":
            | edge_label                 |
            | molecularly_interacts_with |
            | derives_into               |
            | increases_synthesis_of     |
            | increases_degradation_of   |
            | participates_in            |
            | increases_activity_of      |
            | related_to                 |
        and the response only contains the following entries in "edge_label":
            | edge_label                 |
            | molecularly_interacts_with |
            | derives_into               |
            | increases_synthesis_of     |
            | increases_degradation_of   |
            | participates_in            |
            | increases_activity_of      |
            | related_to                 |

    Scenario: Check Rhea Beacon Knowledge Map
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        when we fire "/kmap" query
        then the response contains the following entries in "category" of "subject":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response only contains the following entries in "category" of "subject":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response contains the following entries in "relation" of "predicate":
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        and the response only contains the following entries in "relation" of "predicate":
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        and the response contains the following entries in "category" of "object":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response only contains the following entries in "category" of "object":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |

    Scenario: Check Rhea Beacon concepts
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        when we fire "/concepts?keywords=aspirin&categories=protein" query
        then the response contains "Acetylsalicylate deacetylase." in "name"

    # Rhea doesn't really support exactmatches?
    #Scenario: Check Rhea Beacon exactmatches
    #    Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
    #    when we fire "/exactmatches?c=EC%3A3.1.1.55" query
    #    then the size of the response is 1
    #    and the response should have some JSONPath "$[0].has_exact_matches[0]" with "string" ""

    Scenario: Check Rhea Beacon concept
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        when we fire "/concepts/EC%3A3.1.1.55" query
        then the response should have some JSONPath "id" with "string" "EC:3.1.1.55"
        then the response should have some JSONPath "name" with "string" "Acetylsalicylate deacetylase."
        then the response should have some JSONPath "uri" with "string" "https://enzyme.expasy.org/EC/3.1.1.55"

    Scenario: Check Rhea Beacon statements
        Given a knowledge source at "https://kba.ncats.io/beacon/rhea"
        when we fire "/statements?s=EC%3A3.1.1.55" query
        then the response only contains the following entries in "id" of "subject":
            | id          |
            | EC:3.1.1.55 |
        and the response only contains the following entries in "name" of "subject":
            | name                         |
            | Acetylsalicylate deacetylase.|
        and the response only contains the following entries in "edge_label" of "predicate":
            | edge_label               |
            | increases_synthesis_of   |
            | increases_degradation_of |
            | increases_activity_of    |
        and the response only contains the following entries in "id" of "object":
            | id          |
            | CHEBI:30762 |
            | CHEBI:15378 |
            | CHEBI:30089 |
            | CHEBI:15377 |
            | CHEBI:13719 |
            | RHEA:11752  |

Feature: Check SMPDB Knowledge beacons

    Scenario: Check SMPDB Beacon categories
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        when we fire "/categories" query
        then the response contains the following entries in "category":
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |
        and the response only contains the following entries in "category":
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |

    Scenario: Check SMPDB Beacon predicates
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        when we fire "/predicates" query
        then the response contains the following entries in "relation":
            | relation                        |
            | chemical_affects                |
            | controls_transport_of           |
            | controls_transport_of_chemical  |
            | chemical_to_pathway_association |
            | in_complex_with                 |
            | shares_pathway_with             |
            | interacts_with                  |
            | catalysis_precedes              |
            | used_to_produce                 |
            | consumption_controlled_by       |
            | controls_production_of          |
            | controls_state_change_of        |
            | neighbor_of                     |
            | reacts_with                     |
        and the response only contains the following entries in "relation":
            | relation                        |
            | chemical_affects                |
            | controls_transport_of           |
            | controls_transport_of_chemical  |
            | chemical_to_pathway_association |
            | in_complex_with                 |
            | shares_pathway_with             |
            | interacts_with                  |
            | catalysis_precedes              |
            | used_to_produce                 |
            | consumption_controlled_by       |
            | controls_production_of          |
            | controls_state_change_of        |
            | neighbor_of                     |
            | reacts_with                     |
        and the response contains the following entries in "edge_label":
            | edge_label                      |
            | affects                         |
            | affects_transport_of            |
            | chemical_to_pathway_association |
            | in_complex_with                 |
            | in_pathway_with                 |
            | interacts_with                  |
            | precedes                        |
            | produces                        |
            | related_to                      |
        and the response only contains the following entries in "edge_label":
            | edge_label                      |
            | affects                         |
            | affects_transport_of            |
            | chemical_to_pathway_association |
            | in_complex_with                 |
            | in_pathway_with                 |
            | interacts_with                  |
            | precedes                        |
            | produces                        |
            | related_to                      |

    Scenario: Check SMPDB Beacon Knowledge Map
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        when we fire "/kmap" query
        then the response contains the following entries in "category" of "subject":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response only contains the following entries in "category" of "subject":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response contains the following entries in "relation" of "predicate":
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        and the response only contains the following entries in "relation" of "predicate":
            | relation                                                     |
            | participates in the same reaction side as                    |
            | participates in the opposite reaction side as                |
            | probably increases synthesis (might increase degradation) of |
            | probably increases degradation (might increase synthesis) of |
            | participates_in                                              |
            | increases_activity_of                                        |
            | catalyzes same reaction as                                   |
            | has same catalyst                                            |
        and the response contains the following entries in "category" of "object":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |
        and the response only contains the following entries in "category" of "object":
            | category                   |
            | chemical substance         |
            | protein                    |
            | molecular activity         |

    Scenario: Check SMPDB Beacon concepts
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        when we fire "/concepts?keywords=aspirin&categories=protein" query
        then the response contains "Acetylsalicylate deacetylase." in "name"

    # SMPDB doesn't really support exactmatches?
    #Scenario: Check SMPDB Beacon exactmatches
    #    Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
    #    when we fire "/exactmatches?c=EC%3A3.1.1.55" query
    #    then the size of the response is 1
    #    and the response should have some JSONPath "$[0].has_exact_matches[0]" with "string" ""

    Scenario: Check SMPDB Beacon concept
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        when we fire "/concepts/EC%3A3.1.1.55" query
        then the response should have some JSONPath "id" with "string" "EC:3.1.1.55"
        then the response should have some JSONPath "name" with "string" "Acetylsalicylate deacetylase."
        then the response should have some JSONPath "uri" with "string" "https://enzyme.expasy.org/EC/3.1.1.55"

    Scenario: Check SMPDB Beacon statements
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        when we fire "/statements?s=EC%3A3.1.1.55" query
        then the response only contains the following entries in "id" of "subject":
            | id          |
            | EC:3.1.1.55 |
        and the response only contains the following entries in "name" of "subject":
            | name                         |
            | Acetylsalicylate deacetylase.|
        and the response only contains the following entries in "edge_label" of "predicate":
            | edge_label               |
            | increases_synthesis_of   |
            | increases_degradation_of |
            | increases_activity_of    |
        and the response only contains the following entries in "id" of "object":
            | id          |
            | CHEBI:30762 |
            | CHEBI:15378 |
            | CHEBI:30089 |
            | CHEBI:15377 |
            | CHEBI:13719 |
            | RHEA:11752  |
