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

def fill_template(question, nodemap):
    for node in question['machine_question']['nodes']:
        if 'curie' in node:
            for i,placeholder in enumerate(node['curie']):
                if placeholder in nodemap:
                    node['curie'][i] = nodemap[placeholder]
    return question

question_map={ 'genetic condition providing disease resistance': resistance_question }
