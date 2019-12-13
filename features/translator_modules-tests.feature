Feature: Check Translator Module disease associated genes

    Scenario: Check Translator Module disease associated genes for Fanconi Anemia
        Given the disease identifier "MONDO:0019391" for disease label "Fanconi Anemia" in Translator Modules
            When we run the Translator "Disease Associated Genes" Module
            Then the Translator Module result contains gene identifiers "HGNC:3582,HGNC:3584"

   Scenario: Check Translator Module Phenotype Similarity for Fanconi Anemia
        Given the Translator Modules input "genes" "HGNC:3582,HGNC:3584"
            When we run the Translator "Phenotype Similarity" Module
            Then the Translator Module result contains gene identifiers "HGNC:18160,HGNC:16160"
            And the Translator Module result contains gene symbols "BRCA1,GPN3,DNTTIP1"

   Scenario: Check Translator Module Gene Interactions for Fanconi Anemia
        Given the Translator Modules input "genes" "HGNC:3582,HGNC:3584"
            When we run the Translator "Gene Interaction" Module
            Then the Translator Module result contains gene identifiers "HGNC:12476,HGNC:26144"
            And the Translator Module result contains gene symbols "BRIP1,BARD1,RBBP8"

   # Going to come back to this test later - takes awhile to run(?)
   # Scenario: Check Translator Module Functional Similarity for Fanconi Anemia
   #     Given the Translator Modules input "genes" "HGNC:3582,HGNC:3584"
   #     And module parameters "threshold:0.35"
   #         When we run the Translator "Functional Similarity" Module
   #         Then the Translator Module result contains gene identifiers "HGNC:18536,HGNC:1100"
