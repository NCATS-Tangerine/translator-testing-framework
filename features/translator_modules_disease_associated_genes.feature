Feature: Check Translator module disease associated genes

    Scenario: Check Translator module disease associated genes for "Fanconi Anemia"
        Given a disease term "MONDO:0019391" for Translator Modules
          When we run the disease associated genes module "disease/gene/disease_associated_genes" with parameters "threshold:0"
          Then the response contains "HGNC:3582,HGNC:3584" in "genes" 
