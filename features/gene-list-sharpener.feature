Feature: Check gene-list sharpener

    Background: Specify gene-list sharpener API
        Given a gene-list sharpener at "https://sharpener.ncats.io/api"

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
        when we call "BigGIM gene-expression correlation" transformer with the following parameters:
            | total | tissue |
            | 10    | liver  |
        then the response should have some JSONPath "source" with "string" "BigGIM gene-expression correlation"
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


    Scenario: Check MSigDB hypergeometric enrichment filter
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "MSigDB hypergeometric enrichment filter" transformer with the following parameters:
            | max p-value | max q-value |
            |      0.0009 |    0.05 |
        then the response should have some JSONPath "source" with "string" "MSigDB hypergeometric enrichment filter"
        and the length of the gene list should be 2


    Scenario: Check OMIM common-to-rare disease genes producer
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "OMIM common-to-rare disease genes" transformer with the following parameters:
            | OMIM disease ID |
            | MIM:222100      |
        then the response should have some JSONPath "source" with "string" "OMIM common-to-rare disease genes"
        and the length of the gene list should be 2648


    Scenario: Check disease genes producer
        Given the gene-list sharpener
        when we call "MONDO disease association" transformer with the following parameters:
            | MONDO disease ID |
            | MONDO:0005015    |
        then the response should have some JSONPath "source" with "string" "MONDO disease association"
        and the length of the gene list should be 747


    Scenario: Check phenotype similarity expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "HPO phenotype similarity" transformer with the following parameters:
            | similarity threshold |
            |                  0.5 |
        then the response should have some JSONPath "source" with "string" "HPO phenotype similarity"
        and the length of the gene list should be 36


    Scenario: Check STRING expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "STRING protein-protein interaction" transformer with the following parameters:
            | minimum combined score | minimum neighborhood score | minimum gene fusion score | minimum cooccurence score| minimum coexpression score | minimum experimental score | minimum database score | minimum textmining score | minimum best non-textmining component score | maximum number of genes |
            |                   0.95 |                          0 |                         0 |                        0 |                          0 |                          0 |                      0 |                        0 |                                           0 |                       10|
        then the response should have some JSONPath "source" with "string" "STRING protein-protein interaction"
        and the length of the gene list should be 16


    Scenario: Check gene-interaction expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "BioLink gene-gene interaction" transformer with the following parameters:
            | interaction threshold |
            |                     1 |
        then the response should have some JSONPath "source" with "string" "BioLink gene-gene interaction"
        and the length of the gene list should be 5


    Scenario: Check pathDIP pathway-enrichment expander
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        when we call "pathDIP pathway-enrichment analysis" transformer with the following parameters:
            | maximum number of genes | pathway p-value | gene p-value |
            |                      10 |               1 |         1e-5 |
        then the response should have some JSONPath "source" with "string" "pathDIP pathway-enrichment analysis"
        and the length of the gene list should be 13


    Scenario: Check union
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        and another gene list "ADA,TP53,GPX4"
        when we call gene-list aggregator "union"
        then the response should have some JSONPath "source" with "string" "Gene-list union"
        and the length of the gene list should be 4


    Scenario: Check intersection
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        and another gene list "ADA,TP53,GPX4"
        when we call gene-list aggregator "intersection"
        then the response should have some JSONPath "source" with "string" "Gene-list intersection"
        and the length of the gene list should be 2


    Scenario: Check difference
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        and another gene list "ADA,TP53,GPX4"
        when we call gene-list aggregator "difference"
        then the response should have some JSONPath "source" with "string" "Gene-list difference"
        and the length of the gene list should be 1


    Scenario: Check symmetric difference
        Given the gene-list sharpener
        and a gene list "ADA,EPB41L1,GPX4"
        and another gene list "ADA,TP53,GPX4"
        when we call gene-list aggregator "symmetric difference"
        then the response should have some JSONPath "source" with "string" "Gene-list symmetric difference"
        and the length of the gene list should be 2
