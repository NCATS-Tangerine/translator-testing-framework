Feature: Tests for the RTX reasoning tool

    Scenario: Fanconi anemia gene search produces BRCA2
        Given an "English" question "What genes are associated with Fanconi anemia?"
        When we send the question to RTX
        Then the results should include a node with ID "UniProtKB:P51587"
