Feature: Check Translator Module disease associated genes

    Scenario: Check Translator Module disease associated genes for Fanconi Anemia
        Given the disease identifier "MONDO:0019391" for disease label "Fanconi Anemia" in Translator Modules
            When we run the Translator "Disease Associated Genes" Module
            Then the Translator Module result contains gene identifiers "HGNC:3582,HGNC:3584"

   Scenario: Check Translator Module Phenotype Similarity for Fanconi Anemia
        Given the Translator Modules input "genes" "HGNC:12829,HGNC:1100"
            When we run the Translator "Phenotype Similarity" Module
            Then the Translator Module result contains gene identifiers "HGNC:30579,HGNC:12563"
            And the Translator Module result contains gene symbols "TMEM150B,GPN3,DNTTIP1"

   Scenario: Check Translator Module Gene Interactions for Fanconi Anemia
        Given the Translator Modules input "genes" "HGNC:1100,HGNC:12829"
            When we run the Translator "Gene Interaction" Module
            Then the Translator Module result contains gene identifiers "HGNC:12476,HGNC:26144"
            And the Translator Module result contains gene symbols "BRIP1,BARD1,RBBP8"

   Scenario: Check Translator Module Functional Similarity for Fanconi Anemia
        Given the Translator Modules input "genes" "HGNC:1100,HGNC:12829"
        And module parameters "threshold:0.35"
            When we run the Translator "Functional Similarity" Module
            Then the Translator Module result contains gene identifiers "HGNC:26144,HGNC:18536"
            And the Translator Module result contains gene symbols "RAD54L,FIGNL1,KAT5"
