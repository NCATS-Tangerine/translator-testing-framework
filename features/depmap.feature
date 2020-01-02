Feature: Check depmap knock-out data

    Scenario: Check cell-line list
        Given a knowledge source at "https://indigo.ncats.io/depmap"
        when we fire "/cell_lines" query
        then the size of the response is 1714
        and the response entries contain the following entries in the field "ccle_name"
            | ccle_name             |
            | NIHOVCAR3_OVARY       |
            | CACO2_LARGE_INTESTINE |
            | HCC827_LUNG           |
            | HCC827GR5_LUNG        |


    Scenario: Check gene list
        Given a knowledge source at "https://indigo.ncats.io/depmap"
        when we fire "/genes" query
        then the size of the response is 58179
        and the response entries contain the following entries in the field "gene_symbol"
            | gene_symbol |
            | TSPAN6      |
            | PPIAL4A     |
            | MIR141      |
            | TNMD        |


    Scenario: Check copy-number data
        Given a knowledge source at "https://indigo.ncats.io/depmap"
        when we fire "/copy_number/by_gene/13" query
        then the size of the response is 1626
        and the response should have some JSONPath "[*].entrez_gene_id" with "integer" "13"
        and the response entries contain the following entries in the field "depmap_id"
            | depmap_id  |
            | ACH-000011 |
            | ACH-000687 |
            | ACH-000003 |
            | ACH-001175 |


    Scenario: Check gene-knock-out data
        Given a knowledge source at "https://indigo.ncats.io/depmap"
        when we fire "/gene_dependency/by_gene/13" query
        then the size of the response is 563
        and the response should have some JSONPath "[*].entrez_gene_id" with "integer" "13"
        and the response entries contain the following entries in the field "depmap_id"
            | depmap_id  |
            | ACH-000011 |
            | ACH-000688 |
            | ACH-000004 |
            | ACH-001173 |


    Scenario: Check correlations
        Given a knowledge source at "https://indigo.ncats.io/gene_knockout_correlation"
        when we fire "/correlations/13" query
        then the size of the response is 17621
        and the response should have some JSONPath "[*].entrez_gene_id_1" with "integer" "13"

