Feature: Check similarity and enrichment services from Gamma

    Scenario: Allergic Rhinitis is phenotypically similar to Asthma
        Given identifier MONDO:0004979 and type disease
        When we call gamma similarity with result type disease, intermediate type phenotypic_feature, and threshold 0.0
        Then we expect a HTTP "200"
        And we expect the name of the most similar to be "allergic rhinitis"

    Scenario: Physical activity is GWAS-similar to BMI
        Given identifier EFO:0004340 and type disease_or_phenotypic_feature
        When we call gamma similarity with result type disease_or_phenotypic_feature, intermediate type sequence_variant, and threshold 0.0
        Then we expect a HTTP "200"
        And we expect the name of the most similar to be "physical activity measurement"

    Scenario: tyramine is gene-interaction similar to histamine
        Given identifier CHEBI:18295 and type chemical_substance
        When we call gamma similarity with result type chemical_substance, intermediate type gene, and threshold 0.0
        Then we expect a HTTP "200"
        And we expect the name of the most similar to be "tyramine"

    Scenario: Inflammation is an enriched process in asthma, encephalitis, myocarditis, and colitis
        Given identifiers MONDO:0004979,MONDO:0005292,MONDO:0019956,MONDO:0004496 and type disease
        When we call gamma enrichment with result type biological_process_or_activity
        Then we expect a HTTP "200"
        And we expect the name of the most enriched to be "inflammatory response"

    Scenario: OPRD1 is the most enriched gene from interactions of Fentanyl,Codeine,Morphine,Oxycodone,and Hydrocodone
        Given identifiers CHEBI:17303,CHEBI:16714,CHEBI:7852,CHEBI:5779,CHEBI:119915 and type chemical_substance
        When we call gamma enrichment with result type gene
        Then we expect a HTTP "200"
        And we expect the name of the most enriched to be "OPRD1"
