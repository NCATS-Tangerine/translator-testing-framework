Feature: Check probabilistic graphical models

    Scenario: Check PGM model list
        Given a knowledge source at "https://translator.ncats.io/broad-pgm-translator"
        when we fire "/modelList" query
        then the size of entry "modelID" is 18


    Scenario: Check phenotype-to-variant model signature
        Given a knowledge source at "https://translator.ncats.io/broad-pgm-translator"
        when we fire "/PhenotypeToVariant/modelSignature" query
        then the size of entry "variableGroup" is 2


    Scenario: Check phenotype-to-variant model
        Given a knowledge source at "https://translator.ncats.io/broad-pgm-translator"
        when we fire "/evaluateModel" query with the following body:
        """
        {
          "modelID": "PhenotypeToVariant",
          "modelInput": [
            {
              "variableGroupID": "Phenotypes",
              "modelVariable": [
                {
                  "variableID": "schizophrenia",
                  "priorDistribution": {
                    "discreteDistribution": [
                       { "variableValue": 1, "priorProbability": 0.5 }
                    ]
                  }
                },
                {
                  "variableID": "type-2 diabetes",
                  "priorDistribution": {
                    "discreteDistribution": [
                       { "variableValue": 1, "priorProbability": 0.9 }
                    ]
                  }
                }
              ]
            }
          ],
          "modelOutput": [
            {
              "variableGroupID": "Variants",
              "variableID": ["1_2232532_G_A", "1_2234251_A_G", "1_2236697_A_G"],
              "rawOutput": false
            }
          ]
        }
        """
        then the size of entry "posteriorProbability" is 1
        and the response should have some JSONPath "posteriorProbability[0].modelVariable[2].variableID" with "string" "1_2236697_A_G"

