Feature: Check Translator Module disease associated genes

    Scenario: Check Translator Module disease associated genes for Fanconi Anemia
        Given the disease identifier "MONDO:0019391" for disease label "Fanconi Anemia" in Translator Modules
            When we run the Translator "Disease Associated Genes" Module
            Then the Translator Module result contains "gene" identifiers "HGNC:3582,HGNC:3584"

   Scenario: Check Translator Module Phenotype Similarity for Fanconi Anemia
        Given the Translator Modules input "gene" "HGNC:12829,HGNC:1100"
            When we run the Translator "Phenotype Similarity" Module
            Then the Translator Module result contains "gene" identifiers "HGNC:30579,HGNC:12563"
            And the Translator Module result contains gene symbols "TMEM150B,GPN3,DNTTIP1"

   Scenario: Check Translator Module Gene Interactions for Fanconi Anemia
        Given the Translator Modules input "gene" "HGNC:1100,HGNC:12829"
            When we run the Translator "Gene Interaction" Module
            Then the Translator Module result contains "gene" identifiers "HGNC:12476,HGNC:26144"
            And the Translator Module result contains gene symbols "BRIP1,BARD1,RBBP8"

   Scenario: Check Translator Module Functional Similarity for Fanconi Anemia
        Given the Translator Modules input "gene" "HGNC:1100,HGNC:12829"
        And module parameters "threshold:0.35"
            When we run the Translator "Functional Similarity" Module
            Then the Translator Module result contains "gene" identifiers "HGNC:26144,HGNC:18536"
            And the Translator Module result contains gene symbols "RAD54L,FIGNL1,KAT5"

   Scenario: Check Translator Module Gene to Gene Bicluster of RNASeqDb
        Given the following Translator Modules input "gene" identifiers
            | identifier      |
            | ENSG00000121410 |
            | ENSG00000268895 |
            | ENSG00000148584 |
            | ENSG00000070018 |
            | ENSG00000175899 |
            | ENSG00000245105 |
            | ENSG00000166535 |
            | ENSG00000256661 |
            | ENSG00000256904 |
            | ENSG00000256069 |
            | ENSG00000234906 |
            | ENSG00000068305 |
            | ENSG00000070018 |
            When we run the Translator "Gene to Gene Bicluster RNAseqDB" Module
            Then the Translator Module result contains the following "gene" identifiers
                | identifier      |
                | ENSG00000182150 |
                | ENSG00000118058 |
                | ENSG00000031081 |
                | ENSG00000100320 |

   Scenario: Check Translator Module Gene to Gene Bicluster of DepMap
        Given the following Translator Modules input "gene" identifiers
            | identifier  |
            | NCBI:214    |
            | NCBI:84896  |
            | NCBI:55299  |
            | NCBI:9184   |
            | NCBI:144608 |
            When we run the Translator "Gene to Gene Bicluster DepMap" Module
            Then the Translator Module result contains the following "gene" identifiers
                | identifier  |
                | NCBI:414060 |
                | NCBI:1022   |
                | NCBI:5713   |
                | NCBI:81050  |
                | NCBI:5687   |
                | NCBI:51188  |

   Scenario: Check Translator Module chemical_to_gene_interaction
        Given the following Translator Modules input "chemical" identifiers
            | identifier |
            | D000082    |
            | D006632    |
            When we run the Translator "Chemical to Gene Interaction" Module
            Then the Translator Module result contains the following "gene" identifiers
                | identifier      |
                | NCBIGene:29974  |
                | NCBIGene:21     |
                | NCBIGene:641371 |
                | NCBIGene:25     |
                | NCBIGene:154    |
                | NCBIGene:241    |
