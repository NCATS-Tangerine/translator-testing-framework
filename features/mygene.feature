Feature: Check MyGene.info response

  Scenario: return gene symbol info given a entrez gene id
     Given a valid entrez gene id "1017"
      When we query mygene.info API using this gene id
      Then we expect the symbol to be "CDK2"