Feature: Check BioThings Explorer features

  Scenario: fetch chemicals related to a specific gene
     Given a valid gene symbol "CDK7"
      When we query biothings explorer for chemicals related to this gene
      Then we expect "CRIZOTINIB" is one of the chemicals in the results
    
  Scenario: (Predict) Predict plausible relationships between one entity and an entity class
     Given a valid disease named "hyperphenylalaninemia"
      When we query biothings explorer for drugs that are associated with genes which are invovled in the disease
      Then we expect "DROXIDOPA" is one of the chemicals in the results

  Scenario: (Explain) Identify plausible reasoning chains to explain the relationship between two entities
     Given a valid disease "chronic myelogenous leukemia" and a valid chemical named "imatinib"
      When we query biothings explorer to identify plausible reasoning chains to explain the relationship between two entities
      Then we expect gene "ALK" is one of the explanations that may link the two entities