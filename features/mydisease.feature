Feature: Check MyDisease.info response

  Scenario: return disease ontology ID info given a disease MONDO ID
     Given a valid disease MONDO id "MONDO:0016575"
      When we query mydisease.info API using this disease MONDO id
      Then we expect the disease ontology ID to be "DOID:9562"