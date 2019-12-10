resistance_question = {
  "natural_question": "What genetic conditions may provide protection from a given disease?",
  "machine_question": {
    "nodes": [
      {
        "id": "n0",
        "type": "disease",
        "curie": [
          "input_disease"
        ]
      },
      {
        "id": "n1",
        "type": "gene",
      },
      {
        "id": "n2",
        "type": "genetic_condition",
      }
    ],
    "edges": [
      {
        "id": "e0",
        "source_id": "n0",
        "target_id": "n1"
      },
      {
        "id": "e1",
        "source_id": "n1",
        "target_id": "n2"
      }
    ]
  },
  "max_connectivity": 0
}

cell_question = {
  "natural_question": "what cells are in the brain?",
  "machine_question": {
    "nodes": [
      {
        "id": "n0",
        "type": "anatomical_entity",
        "set": False,
        "curie": [
          "input_entity"
        ]
      },
      {
        "id": "n1",
        "type": "cell",
        "set": False
      }
    ],
    "edges": [
      {
        "type": [
          "part_of"
        ],
        "id": "e0",
        "source_id": "n1",
        "target_id": "n0"
      }
    ]
  },
  "max_connectivity": 0
}

variant_question = {
  "natural_question": "genes affecting chemicals related to disease, which has a variant related to the gene",
  "machine_question": {
    "nodes": [
      {
        "id": "n0",
        "type": "disease",
        "curie": [
          "input_disease"
        ],
        "set": False
      },
      {
        "id": "n1",
        "type": "sequence_variant",
        "set": False
      },
      {
        "id": "n2",
        "type": "gene",
        "set": False
      },
      {
        "id": "n3",
        "type": "chemical_substance",
        "set": False
      }
    ],
    "edges": [
      {
        "id": "e0",
        "source_id": "n0",
        "target_id": "n1"
      },
      {
        "id": "e1",
        "source_id": "n1",
        "target_id": "n2"
      },
      {
        "type": [
          "increases_degradation_of"
        ],
        "id": "e2",
        "source_id": "n2",
        "target_id": "n3"
      },
      {
        "id": "e3",
        "source_id": "n0",
        "target_id": "n3"
      }
    ]
  },
  "max_connectivity": 0
}


expression_question={
  "natural_question": "Find a drug that increases expression of a gene with decreased expression in a phenotype",
  "machine_question": {
    "nodes": [
      {
        "id": "n0",
        "type": "disease_or_phenotypic_feature",
        "set": False,
        "curie": [
          "input_entity"
        ]
      },
      {
        "id": "n1",
        "type": "sequence_variant",
        "set": False
      },
      {
        "id": "n2",
        "type": "gene",
        "set": False
      },
      {
        "id": "n3",
        "type": "chemical_substance",
        "set": False,
        "drug": True
      }
    ],
    "edges": [
      {
        "id": "e0",
        "source_id": "n0",
        "target_id": "n1"
      },
      {
        "type": [
          "decreases_expression_of"
        ],
        "id": "e1",
        "source_id": "n1",
        "target_id": "n2"
      },
      {
        "type": [
          "increases_expression_of"
        ],
        "id": "e2",
        "source_id": "n3",
        "target_id": "n2"
      }
    ]
  },
  "max_connectivity": 0
}

degreasers_question={
  "natural_question": "Genes that relate to degreasers, share a process and a specified disease",
  "machine_question": {
    "nodes": [
      {
        "id": "n0",
        "type": "chemical_substance",
        "set": False,
        "curie": [
          "CHEBI:15347"
        ]
      },
      {
        "id": "n1",
        "type": "chemical_substance",
        "set": False,
        "curie": [
          "CHEBI:35290"
        ]
      },
      {
        "id": "n2",
        "type": "chemical_substance",
        "set": False,
        "curie": [
          "CHEBI:16602"
        ]
      },
      {
        "id": "n3",
        "type": "gene",
        "set": False
      },
      {
        "id": "n4",
        "type": "gene",
        "set": False
      },
      {
        "id": "n5",
        "type": "gene",
        "set": False
      },
      {
        "id": "n6",
        "type": "disease",
        "set": False,
        "curie": [
          "input_disease"
        ]
      },
      {
        "id": "n7",
        "type": "biological_process_or_activity",
        "set": False
      }
    ],
    "edges": [
      {
        "id": "e0",
        "source_id": "n0",
        "target_id": "n3"
      },
      {
        "id": "e1",
        "source_id": "n1",
        "target_id": "n4"
      },
      {
        "id": "e2",
        "source_id": "n2",
        "target_id": "n5"
      },
      {
        "id": "e3",
        "source_id": "n6",
        "target_id": "n3"
      },
      {
        "id": "e4",
        "source_id": "n4",
        "target_id": "n6"
      },
      {
        "id": "e5",
        "source_id": "n6",
        "target_id": "n5"
      },
      {
        "id": "e6",
        "source_id": "n7",
        "target_id": "n3"
      },
      {
        "id": "e7",
        "source_id": "n4",
        "target_id": "n7"
      },
      {
        "id": "e8",
        "source_id": "n5",
        "target_id": "n7"
      }
    ]
  },
  "max_connectivity": 0
}

cop_question = {
  "natural_question": "Clinical Outcome Pathway",
  "machine_question": {
    "nodes": [
      {
        "id": "n0",
        "type": "chemical_substance",
        "set": False,
        "curie": [
          "input_chemical"
        ]
      },
      {
        "id": "n1",
        "type": "gene",
        "set": False
      },
      {
        "id": "n2",
        "type": "biological_process_or_activity",
        "set": True
      },
      {
        "id": "n3",
        "type": "cell",
        "set": False
      },
      {
        "id": "n4",
        "type": "anatomical_entity",
        "set": False
      },
      {
        "id": "n5",
        "type": "phenotypic_feature",
        "set": False,
        "curie": [
          "input_phenotype"
        ]
      }
    ],
    "edges": [
      {
        "id": "e0",
        "source_id": "n0",
        "target_id": "n1"
      },
      {
        "id": "e1",
        "source_id": "n1",
        "target_id": "n2"
      },
      {
        "id": "e2",
        "source_id": "n2",
        "target_id": "n3"
      },
      {
        "id": "e3",
        "source_id": "n3",
        "target_id": "n4"
      },
      {
        "id": "e4",
        "source_id": "n4",
        "target_id": "n5"
      }
    ]
  },
  "max_connectivity": 0
}

def fill_template(question, nodemap):
    for node in question['machine_question']['nodes']:
        if 'curie' in node:
            for i,placeholder in enumerate(node['curie']):
                if placeholder in nodemap:
                    node['curie'][i] = nodemap[placeholder]
    return question

question_map={ 'genetic condition providing disease resistance': resistance_question,
               'cells that are part of an anatomical entity': cell_question,
               'GWAS related genes that metabolize relevant chemicals': variant_question,
               'Drug that reverses expression change': expression_question,
               'Functionally similar genes relating degreasers to disease': degreasers_question,
               'Clincal Outcome Pathway from chemical to phenotype': cop_question}

