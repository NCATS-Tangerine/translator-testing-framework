Feature: Check SemMedDb Knowledge Beacon

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
        Then the size of the response is 1
        And the response should have some entry with field "id" with "string" "UMLS:C1414527"
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


    Scenario: Check one particular SemMedDb statement
        Given a knowledge source at "https://kba.ncats.io/beacon/semmeddb"
        When we fire "/statements/UMLS%3AC1414527%3Atreats%3AUMLS%3AC0006142" query
        Then the response should have a field "id" with "string" "UMLS:C1414527:treats:UMLS:C0006142"
        And the response should have a field "provided_by" with "string" "semmeddb_sulab"
