Feature: Check ROBOKOP quick responses

    Scenario: Ebola Query produces Niemann-Pick Disease
        Given a question "genetic condition providing disease resistance" 
        And node mappings
        """
        {"input_disease":"MONDO:0005737"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/" 
        Then we expect a HTTP "200"
        Then the response should have some JSONPath "answers[0].node_bindings.n2[0]" with "string" "MONDO:0001982"

    Scenario: Brain cells are mostly neurons
        Given a question "cells that are part of an anatomical entity"
        And node mappings
        """
        {"input_entity":"UBERON:0000955"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/" 
        Then we expect a HTTP "200"
        And at least 7 of the top 10 names of node n1 should contain the text "neuron"

    Scenario: NAT2 related to tuberculosis
        Given a question "GWAS related genes that metabolize relevant chemicals"
        And node mappings
        """
        {"input_disease":"MONDO:0018076"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/"
        Then we expect a HTTP "200"
        And the response should have some JSONPath "answers[0].node_bindings.n2[0]" with "string" "HGNC:7646"

    Scenario: Drugs to modify LDL levels
        Given a question "Drug that reverses expression change"
        And node mappings
        """
        {"input_entity":"EFO:0004611"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/"
        Then we expect a HTTP "200"
        And the top 10 names of node n3 should contain "rosiglitazone,troglitazone,bezafibrate,fenofibrate,clofibrate"

    Scenario: Genes relating degreasers to colitis
        Given a question "Functionally similar genes relating degreasers to disease"
        And node mappings
        """
        {"input_disease":"MONDO:0005292"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/"
        Then we expect a HTTP "200"
        And the response should have some JSONPath "answers[0].node_bindings.n3[0]" with "string" "HGNC:1516"
        And the response should have some JSONPath "answers[0].node_bindings.n4[0]" with "string" "HGNC:1516"
        And the response should have some JSONPath "answers[0].node_bindings.n5[0]" with "string" "HGNC:11892"

    Scenario: Mizolastine/Rhinitis COP finds HRH1, Mast cells
        Given a question "Clincal Outcome Pathway from chemical to phenotype"
        And node mappings
        """
        {"input_chemical":"CHEBI:31857",
         "input_phenotype":"HP:0003193"}
        """
        When we fire the query to URL "https://robokop.renci.org/api/simple/quick/"
        Then we expect a HTTP "200"
        And the response should have some JSONPath "answers[0].node_bindings.n1[0]" with "string" "HGNC:5182"
        And the response should have some JSONPath "answers[0].node_bindings.n3[0]" with "string" "CL:0000097"

