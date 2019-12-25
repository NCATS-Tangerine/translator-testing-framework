Feature: Check SMPDB Knowledge Beacon

    Scenario: Check SMPDB Beacon categories
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/categories" query
        Then the response entries contain the following entries in the field "category"
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |
        And the response only contains the following entries in "category"
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |

    Scenario: Check SMPDB Beacon predicates
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/predicates" query
        Then the response entries contain the following entries in the field "relation"
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
        And the response only contains the following entries in "relation"
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
        And the response entries contain the following entries in the field "edge_label"
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
        And the response only contains the following entries in "edge_label"
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

    Scenario: Check SMPDB Beacon Name Space
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/namespaces" query
        Then the response entries contain the following entries in the field "local_prefix"
            | local_prefix |
            | CHEBI        |
            | HMDB         |
        And the response only contains the following entries in "local_prefix"
            | local_prefix |
            | CHEBI        |
            | HMDB         |

    Scenario: Check SMPDB Beacon Knowledge Map
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/kmap" query
        Then the response contains the following entries in "category" of "subject"
            | category           |
            | chemical substance |
            | metabolite         |
            | protein            |
        And the response only contains the following entries in "category" of "subject"
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |
        And the response contains the following entries in "relation" of "predicate"
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
        And the response only contains the following entries in "relation" of "predicate"
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
        And the response contains the following entries in "edge_label" of "predicate"
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
        And the response only contains the following entries in "edge_label" of "predicate"
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
        And the response contains the following entries in "category" of "object"
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |
        And the response only contains the following entries in "category" of "object"
            | category           |
            | chemical substance |
            | metabolite         |
            | pathway            |
            | protein            |

    Scenario: Check keyword query of SMPDB Beacon concepts
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/concepts?keywords=acetaldehyde" query
        Then some entry in the response contains "metabolite" in field "categories"
        And some entry in the response contains one of the following values in field "id"
            | id          |
            | CHEBI:27978 |
            | CHEBI:15343 |
            | CHEBI:28104 |
            | CHEBI:27398 |
            | CHEBI:50157 |
            | CHEBI:18086 |
            | CHEBI:27871 |
        And some entry in the response contains one of the following values in field "name"
            | name                            |
            | 3,4-Dihydroxyphenylacetaldehyde |
            | Acetaldehyde                    |
            | Methylimidazole acetaldehyde    |
            | Imidazole-4-acetaldehyde        |
            | 5-Hydroxyindoleacetaldehyde     |
            | Indoleacetaldehyde              |
            | Chloroacetaldehyde              |

    # SMPDB doesn't really support exactmatches?
    #Scenario: Check SMPDB Beacon exactmatches
    #    Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
    #    When we fire "/exactmatches?c=CHEBI%3A18086" query
    #    Then the size of the response is 1
    #    And the response should have some JSONPath "$[0].has_exact_matches[0]" with "string" ""

    Scenario: Check one particular SMPDB Beacon concept
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/concepts/CHEBI%3A18086" query
        Then the response should have a field "id" with "string" "CHEBI:18086"
        Then the response should have a field "name" with "string" "Indoleacetaldehyde"
        Then the response should have a field "uri" with "string" "https://www.ebi.ac.uk/chebi/searchId.do?chebiId=CHEBI:18086"

    Scenario: Check SMPDB Beacon statements
        Given a knowledge source at "https://kba.ncats.io/beacon/smpdb"
        When we fire "/statements?s=CHEBI%3A18086" query
        Then the response only contains the following entries in "id" of "subject"
            | id          |
            | CHEBI:18086 |
        And the response only contains the following entries in "name" of "subject"
            | name               |
            | Indoleacetaldehyde |
        And the response only contains the following entries in "edge_label" of "predicate"
            | edge_label                      |
            | produces                        |
            | in_pathway_with                 |
            | related_to                      |
            | chemical_to_pathway_association |
        And the response only contains the following entries in "id" of "object"
            | id             |
            | CHEBI:16411    |
            | CHEBI:27823    |
            | UNIPROT:P46597 |
            | UNIPROT:P05091 |
            | CHEBI:28715    |
            | UNIPROT:O15229 |
            | UNIPROT:O95050 |
            | CHEBI:995      |
            | UNIPROT:Q8TDX5 |
            | SMP:SMP0000063 |
        And the response only contains the following entries in "name" of "object"
            | name              |
            | Indoleacetic acid |
            | 5-Hydroxyindoleacetic acid |
            | Acetylserotonin O-methyltransferase |
            | Aldehyde dehydrogenase, mitochondrial |
            | 5-Hydroxykynurenamine |
            | Kynurenine 3-monooxygenase  |
            | Indolethylamine N-methyltransferase |
            | 2-Amino-3-carboxymuconic acid semialdehyde |
            | 2-amino-3-carboxymuconate-6-semialdehyde decarboxylase |
            | Tryptophan Metabolism |
