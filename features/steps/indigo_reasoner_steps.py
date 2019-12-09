from behave import given, when, then
import requests
from contextlib import closing
import json


@given('"{subject_type}" "{subject_name}" with ID "{subject_id}"')
def step_impl(context, subject_type, subject_name, subject_id):
    """
    Given an input query node
    """
    context.subject_type = subject_type
    context.subject_name = subject_name
    context.subject_id = subject_id


@when('we query RLR for "{query}"')
def step_impl(context, query):
    """
    Send a query to the Indigo reinforcement learning reasoner
    """
    context.query_json = {"message": {
                            "query_graph": {
                              "nodes": [
                                {
                                  "id": "n00",
                                  "curie": "185855",
                                  "type": "chemical_substance"
                                },
                                {
                                  "id": "n01",
                                  "curie": "?",
                                  "type": "disease"
                                }
                              ],
                              "edges": [
                                {
                                  "id": "e00",
                                  "type": "HAS_INDICATION",
                                  "source_id": "n00",
                                  "target_id": "n01"
                                }
                              ]
                            }
                          }
                        }

    url = "https://indigo.ncats.io/rlr/api/v0"
    headers = {'accept': 'application/json'}

    print(context.query_json)
    print(url)

    with closing(requests.post(url + "/query", json=context.query_json, headers=headers)) as response:
        print(response)
        print(json.loads(response.json())[0]["nodes"])
        context.code = response.status_code
        context.content_type = response.headers['content-type']
        assert response.status_code == 200
        context.response = response
        context.response_text = response.text
        context.response_json = response.json()

@then('the answer graph contains the following nodes')
def step_impl(context):
    """
    Test whether the answer graph includes the nodes provided in the feature file
    """
    response = json.loads(context.response_json)
    node_ids = set()
    print('Collected entries:')
    for node in response[0]["nodes"]:
        print(' ', node['id'])
        node_ids.add(node['id'])
    print('Tested entries:')
    for row in context.table:
        print(' ', row['id'])
        assert int(row['id']) in node_ids

@when('we query IndigoR for "{query}"')
def step_impl(context, query):
    """
    Send a query to the Indigo workflow reasoner
    """
    if query == "protein targets":
        query_relation = "targets"
        target_type = "protein"

    if context.subject_type == "chemical substance":
        subject_type = "chemical_substance"

    print(query)

    context.query_json = {"asynchronous": "false",
                          "bypass_cache": "true",
                          "max_results": 100,
                          "page_number": 1,
                          "page_size": 20,
                          "previous_message_processing_plan": {},
                          "query_message": {
                          "query_graph": {
                            "edges": [
                              {
                                "edge_id": "e00",
                                "source_id": "n00",
                                "target_id": "n01",
                                "type": query_relation
                              }
                            ],
                            "nodes": [
                              {
                                "curie": context.subject_id,
                                "node_id": "n00",
                                "type": subject_type
                              },
                              {
                                "node_id": "n01",
                                "type": target_type
                              }
                            ]
                          }

                        },
                          "reasoner_ids": [
                            "RTX",
                            "Robokop"
                          ]
                          
                        }

    url = "https://indigo.ncats.io/reasoner/api/v1"
    headers = {'accept': 'application/json'}

    print(context.query_json)
    print(url)

    with closing(requests.post(url + "/query", json=context.query_json, headers=headers)) as response:
        print(response)
        print(response.json())
        context.code = response.status_code
        context.content_type = response.headers['content-type']
        assert response.status_code == 200
        context.response = response
        context.response_text = response.text
        context.response_json = response.json()


@then('the result graph contains the following nodes')
def step_impl(context):
    """
    Test whether the answer graph includes the nodes provided in the feature file
    """
    response = context.response_json
    node_ids = set()
    print('Collected entries:')
    for result in response["results"]:
        for node in result["result_graph"]["nodes"]:
            print(' ', node['id'])
            node_ids.add(node['id'])
    print('Tested entries:')
    for row in context.table:
        print(' ', row['id'])
        assert row['id'] in node_ids
