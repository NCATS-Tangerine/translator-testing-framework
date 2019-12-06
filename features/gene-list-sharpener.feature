Feature: Check gene-list sharpener

    Background: Specify gene-list sharpener API
        Given a gene-list sharpener at "http://chembio-dev-01:9010/api"


    Scenario: Check gene-list transformers
        Given the gene-list sharpener
        when we fire "/transformers" query
        then the response contains the following entries in "status":
            | status |
            | online |
        and the response only contains the following entries in "status":
            | status |
            | online |


    Scenario: Check create gene-list producer
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we request the gene list
        then the length of the gene list should be 3


    Scenario: Check Pharos filter
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "Pharos filter" transformer with the following parameters:
            | field                                | op | value|
            | HPM Protein Tissue Specificity Index | <  | 0.5  |
        then the response should have some JSONPath "source" with "string" "Pharos filter"
        and the length of the gene list should be 2


    Scenario: Check random producer
        Given the gene-list sharpener
        when we call "Random gene list" transformer with the following parameters:
            | number |
            | 8      |
        then the response should have some JSONPath "source" with "string" "Random gene list"
        and the length of the gene list should be 8


    Scenario: Check MSigDB producer
        Given the gene-list sharpener
        when we call "MSigDB gene-set content" transformer with the following parameters:
            | gene set name       |
            | REACTOME_GLYCOLYSIS |
        then the response should have some JSONPath "source" with "string" "MSigDB gene-set content"
        and the length of the gene list should be 72


    Scenario: Check DepMap expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "DepMap co-fitness correlation" transformer with the following parameters:
            | correlation threshold | correlation direction | correlated values |
            | 0.27                  | correlation           | gene knockout     |
        then the response should have some JSONPath "source" with "string" "DepMap co-fitness correlation"
        and the length of the gene list should be 24


    Scenario: Check Big GIM expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "Big GIM expression correlation" transformer with the following parameters:
            | total | tissue |
            | 10    | liver  |
        then the response should have some JSONPath "source" with "string" "Big GIM expression correlation"
        and the length of the gene list should be 13


    Scenario: Check attribute filter
        Given the gene-list sharpener
        and a gene list "EPB41L1,MCC,GPX4"
        when we call "Remove genes by attribute value" transformer with the following parameters:
            | attribute name | operand | attribute value |
            | synonyms       | !=      | MCC1            |
        then the response should have some JSONPath "source" with "string" "Remove genes by attribute value"
        and the length of the gene list should be 2


    Scenario: Check remove-genes filter
        Given the gene-list sharpener
        and a gene list "EPB41L1,MCC,GPX4"
        when we call "Remove genes by gene symbol" transformer with the following parameters:
            | gene symbol(s) |
            | EPB41L1,GPX4   |
        then the response should have some JSONPath "source" with "string" "Remove genes by gene symbol"
        and the length of the gene list should be 1


    Scenario: Check MSigDB hypergeometric enrichment expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "MSigDB hypergeometric enrichment expander" transformer with the following parameters:
            | maximum p-value | maximum q-value |
            |          0.0009 |            0.05 |
        then the response should have some JSONPath "source" with "string" "MSigDB hypergeometric enrichment expander"
        and the length of the gene list should be 17

