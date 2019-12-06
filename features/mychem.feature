Feature: Check MyChem.info response

  Scenario: return chemical name info given a chemical ChEMBL ID
     Given a valid chemical ChEMBL id "CHEMBL744"
      When we query mychem.info API using this chemical ChEMBL id
      Then we expect the chemical name to be "RILUZOLE"