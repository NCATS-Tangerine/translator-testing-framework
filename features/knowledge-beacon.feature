Feature: Check Knowledge Beacons

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


    Scenario: Check SemMedDb Beacon Categories
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/categories" query
        Then the response entries contain the following entries in the field "category"
            | category                       |
            | chemical substance             |
            | disease or phenotypic feature  |
            | gene                           |
            | biological entity              |
            | protein                        |
            | gross anatomical structure     |
            | biological process or activity |
            | anatomical entity              |
            | named thing                    |
            | cell                           |
            | activity and behavior          |
            | phenotypic feature             |
            | genomic entity                 |
        And the response only contains the following entries in "category"
            | category                       |
            | chemical substance             |
            | disease or phenotypic feature  |
            | gene                           |
            | biological entity              |
            | protein                        |
            | gross anatomical structure     |
            | biological process or activity |
            | anatomical entity              |
            | named thing                    |
            | cell                           |
            | activity and behavior          |
            | phenotypic feature             |
            | genomic entity                 |

    Scenario: Check SemMedDb Beacon Predicates
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/predicates" query
        Then the response entries contain the following entries in the field "relation"
            | relation |
            | semmeddb:affects |
            | semmeddb:interacts_with |
            | semmeddb:location_of |
            | semmeddb:coexists_with |
            | semmeddb:part_of |
            | semmeddb:positively_regulates |
            | semmeddb:negatively_regulates |
            | semmeddb:causes |
            | semmeddb:treats |
            | semmeddb:produces |
            | semmeddb:related_to |
            | semmeddb:gene_associated_with_condition |
            | semmeddb:subclass_of |
            | semmeddb:predisposes |
            | semmeddb:prevents |
            | semmeddb:derives_into |
            | semmeddb:manifestation_of |
            | semmeddb:precedes |
        And the response only contains the following entries in "relation"
            | relation |
            | semmeddb:affects |
            | semmeddb:interacts_with |
            | semmeddb:location_of |
            | semmeddb:coexists_with |
            | semmeddb:part_of |
            | semmeddb:positively_regulates |
            | semmeddb:negatively_regulates |
            | semmeddb:causes |
            | semmeddb:treats |
            | semmeddb:produces |
            | semmeddb:related_to |
            | semmeddb:gene_associated_with_condition |
            | semmeddb:subclass_of |
            | semmeddb:predisposes |
            | semmeddb:prevents |
            | semmeddb:derives_into |
            | semmeddb:manifestation_of |
            | semmeddb:precedes |
        And the response entries contain the following entries in the field "edge_label"
            | edge_label |
            | affects |
            | interacts_with |
            | location_of |
            | coexists_with |
            | part_of |
            | positively_regulates |
            | negatively_regulates |
            | causes |
            | treats |
            | produces |
            | related_to |
            | gene_associated_with_condition |
            | subclass_of |
            | predisposes |
            | prevents |
            | derives_into |
            | manifestation_of |
            | precedes |
        And the response only contains the following entries in "edge_label"
            | edge_label |
            | affects |
            | interacts_with |
            | location_of |
            | coexists_with |
            | part_of |
            | positively_regulates |
            | negatively_regulates |
            | causes |
            | treats |
            | produces |
            | related_to |
            | gene_associated_with_condition |
            | subclass_of |
            | predisposes |
            | prevents |
            | derives_into |
            | manifestation_of |
            | precedes |

    Scenario: Check SemMedDb Beacon Name Space
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/namespaces" query
        Then the response entries contain the following entries in the field "local_prefix"
            | local_prefix |
            | UMLS        |
        And the response only contains the following entries in "local_prefix"
            | local_prefix |
            | UMLS         |

    Scenario: Check SemMedDb Beacon Knowledge Map
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/kmap" query
        Then the response contains the following entries in "category" of "subject"
            | category                       |
            | chemical substance             |
            | disease or phenotypic feature  |
            | gene                           |
            | biological entity              |
            | protein                        |
            | gross anatomical structure     |
            | biological process or activity |
            | anatomical entity              |
            | cell                           |
            | cell component                 |
            | activity and behavior          |
            | phenotypic feature             |
            | genomic entity                 |
        And the response only contains the following entries in "category" of "subject"
            | category                       |
            | chemical substance             |
            | disease or phenotypic feature  |
            | gene                           |
            | biological entity              |
            | protein                        |
            | gross anatomical structure     |
            | biological process or activity |
            | anatomical entity              |
            | cell                           |
            | cell component                 |
            | activity and behavior          |
            | phenotypic feature             |
            | genomic entity                 |
        And the response contains the following entries in "edge_label" of "predicate"
            | edge_label                     |
            | affects                        |
            | interacts_with                 |
            | location_of                    |
            | coexists_with                  |
            | part_of                        |
            | positively_regulates           |
            | negatively_regulates           |
            | causes                         |
            | treats                         |
            | produces                       |
            | related_to                     |
            | gene_associated_with_condition |
            | subclass_of                    |
            | predisposes                    |
            | prevents                       |
            | derives_into                   |
            | manifestation_of               |
            | precedes                       |
        And the response only contains the following entries in "edge_label" of "predicate"
            | edge_label                     |
            | affects                        |
            | interacts_with                 |
            | location_of                    |
            | coexists_with                  |
            | part_of                        |
            | positively_regulates           |
            | negatively_regulates           |
            | causes                         |
            | treats                         |
            | produces                       |
            | related_to                     |
            | gene_associated_with_condition |
            | subclass_of                    |
            | predisposes                    |
            | prevents                       |
            | derives_into                   |
            | manifestation_of               |
            | precedes                       |
        And the response contains the following entries in "category" of "object"
            | category                       |
            | chemical substance             |
            | disease or phenotypic feature  |
            | gene                           |
            | biological entity              |
            | protein                        |
            | gross anatomical structure     |
            | biological process or activity |
            | anatomical entity              |
            | cell                           |
            | cell component                 |
            | activity and behavior          |
            | phenotypic feature             |
            | genomic entity                 |
        And the response only contains the following entries in "category" of "object"
            | category                       |
            | chemical substance             |
            | disease or phenotypic feature  |
            | gene                           |
            | biological entity              |
            | protein                        |
            | gross anatomical structure     |
            | biological process or activity |
            | anatomical entity              |
            | cell                           |
            | cell component                 |
            | activity and behavior          |
            | phenotypic feature             |
            | genomic entity                 |

    Scenario: Check keyword query of SemMedDb Beacon Concepts
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/concepts?keywords=FANCA" query
        Then some entry in the response contains "gene" in field "categories"
        And some entry in the response contains one of the following values in field "id"
            | id            |
            | UMLS:C0531299 |
            | UMLS:C1414527 |
            | UMLS:C2828026 |
        And some entry in the response contains one of the following values in field "name"
            | name                 |
            | FANCA protein, human |
            | FANCA gene           |
            | FANCA wt Allele      |

    Scenario: Check one particular SemMedDb Beacon Concept
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/concepts/UMLS%3AC1414527" query
        Then the response should have a field "id" with "string" "UMLS:C1414527"
        And the response should have a field "name" with "string" "FANCA gene"
        And the response contains the following entries in the field "exact_matches"
            | exact_matches           |
            | HGNC:HGNC:3582          |
            | OMIM:607139             |
            | NCI_NCI-HGNC:HGNC:3582  |
            | NCI:C85995              |
            | MTH:NOCODE              |

    Scenario: Check SemMedDb Beacon Exactmatches
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/exactmatches?c=UMLS%3AC1414527" query
        Then the response should have some entry with field "id" with "string" "UMLS:C1414527"
        And the response should have some entry with field "within_domain" with "boolean" "True"
        And the response entries contain the following entries in the field "has_exact_matches"
            | has_exact_matches      |
            | HGNC:HGNC:3582         |
            | OMIM:607139            |
            | NCI_NCI-HGNC:HGNC:3582 |
            | NCI:C85995             |
            | MTH:NOCODE             |
            | UMLS:C1414527          |


    Scenario: Check SemMedDb Beacon Statements
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/statements?s=UMLS%3AC1414527" query
        Then the response only contains the following entries in "id" of "subject"
            | id            |
            | UMLS:C1414527 |
        And the response only contains the following entries in "name" of "subject"
            | name       |
            | FANCA gene |
        And the response only contains the following entries in "categories" of "subject"
            | categories |
            | gene       |
        And the response only contains the following entries in "edge_label" of "predicate"
            | edge_label                     |
            | treats                         |
            | part_of                        |
            | coexists_with                  |
            | causes                         |
            | gene_associated_with_condition |
            | affects                        |
        And the response only contains the following entries in "id" of "object"
            | id |
            | UMLS:C0006142 |
            | UMLS:C0023467 |
            | UMLS:C0162326 |
            | UMLS:C0015625 |
            | UMLS:C0235974 |
            | UMLS:C0687133 |
        And the response only contains the following entries in "name" of "object"
            | name                         |
            | Malignant neoplasm of breast |
            | Leukemia, Myelocytic, Acute  |
            | DNA Sequence                 |
            | Fanconi Anemia               |
            | Pancreatic carcinoma         |
            | Drug Interactions            |
        And the response only contains the following entries in "categories" of "object"
            | categories                    |
            | disease or phenotypic feature |
            | genomic entity                |
