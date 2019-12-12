Feature: Check Translator Module disease associated genes

    Scenario: Check Translator Module disease associated genes for Fanconi Anemia
        Given the disease identifier "MONDO:0019391" for disease label "Fanconi Anemia" in Translator Modules
            When we run the Translator "Disease Associated Genes" Module
            Then the Translator Module result contains "HGNC:3582,HGNC:3584"

    Scenario: Check Translator Module Gene Interactions for Fanconi Anemia
        Given the Translator Modules input "genes" "HGNC:3582,HGNC:3584"
            When we run the Translator "Gene Interaction" Module
            Then the Translator Module result contains "HGNC:3582,HGNC:3584"
