Feature: Check Translator module disease associated genes

    Scenario: Check Translator module disease associated genes for "Fanconi Anemia"
        Given a disease identifier "MONDO:0019391" for disease label "Fanconi Anemia" in Translator Modules
          When we run the disease associated genes Translator Module
          Then the module result contains "HGNC:3582,HGNC:3584" 
