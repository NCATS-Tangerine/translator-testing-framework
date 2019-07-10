import jsonpath_rw
import logging
import requests
import json
import sys
from behave import given, when, then
from contextlib import closing
from reasoner_diff.test_robokop import answer as robokop_answer
from reasoner_diff.test_robokop import question as robokop_question
from reasoner_diff.test_robokop import headers as robokop_headers
from reasoner_diff.test_rtx import answer as rtx_answer


"""
Given
"""


@given('a query graph "{reasoner}"')
def step_impl(context, reasoner):
    """
    Fetch query graph for a reasoner.

    Note: This is for prototyping purposes. Ideally the query graph should be constructed ahead accordingly
    """
    query_graph_map = {
        'RTX': {

        },
        'ROBOKOP': {

        }
    }
    assert reasoner in query_graph_map
    context.query_graph = query_graph_map[reasoner]


@given('an answer graph from "{reasoner}"')
def step_impl(context, reasoner):
    """
    Fetch an answer graph for a reasoner.

    Note: This is for prototyping purposes. Ideally the answer graph should be the response from a reasoner
    and not a hard coded JSON blob.

    """
    answer_graph_map = {
        'RTX': rtx_answer,
        'ROBOKOP': robokop_answer
    }
    assert reasoner in answer_graph_map
    if 'answer_graphs' not in context:
        context.answer_graphs = []
    context.answer_graphs.append(answer_graph_map[reasoner])


"""
When
"""


@when('we fire the query to "{reasoner}" with URL "{url}" we expect a HTTP "{status_code:d}"')
def step_impl(context, reasoner, url, status_code):
    print("testing "+reasoner)


    """
    Fire a query to a reasoner.

    Note: Implementation is incomplete. Right now it simply uses a hard coded JSON blob as response
    instead of actually firing a query to a reasoner
    """
    # This block is only for prototyping purpose. Long term, URL should never be None
    if reasoner == "RTX" and eval(url) is None:
        context.response_text = str(rtx_answer)
        context.response_json = rtx_answer
    elif reasoner == "ROBOKOP" and eval(url) is None:
        context.response_text = str(robokop_answer)
        context.response_json = robokop_answer
    else:
        with closing(requests.put(url, stream=False)) as response:
            context.code = response.status_code
            context.content_type = response.headers['content-type']
            assert response.status_code == status_code
            context.response_text = response.text
            context.response_json = response.json()

@when('we fire an actual query to "{reasoner}" with URL "{url}" we expect a HTTP "{status_code:d}"')
def step_impl(context, reasoner, url, status_code):
    """
    This step fires a query, defined in test_robokop.py, to the provided url and stores the response
    as response_json in context.  We can then write further steps to analyze this response in whatever
    way is needed.  Future revisions should allow the passing of different queries, rather than relying on
    the hardcoded one from test_robokop.py
    """
    with closing(requests.post(url,data=json.dumps(robokop_question),headers=robokop_headers)) as response:
        context.code = response.status_code
        context.content_type = response.headers['content-type']
        print(response.status_code)
        assert response.status_code == status_code
        context.response_text = response.text
        context.response_json = response.json()
@when('we compare the answer graphs')
def step_impl(context):
    """
    Fires a query to a locally running service for comparing answers from two reasoners.

    """
    answer_graphs = context.answer_graphs
    response = requests.post(
        "{}/compare_answers".format(context.target),
        json={
            "answer_1": answer_graphs[0],
            "answer_2": answer_graphs[1]
        },
        headers={
            'accept': 'application/json'
        })
    assert response.status_code == 200
    context.response_text = response.text
    context.response_json = response.json()

"""
Then
"""


@then('the response should contain "{value}"')
def step_impl(context, value):
    """
    Check if the response contains a given string.

    """
    assert context.response_text.rfind(value) != -1

@then('the response should have some node with id "{id}" and field "{field}" with value "{value}"')
def step_impl(context,id,field,value):
    """this step will search a returned answer graph for a node with id (or equivalent_identifier)
    equal to the provide id, and a node[{field}]==value and return true if the answer graph has
    at least one such node
    """
    results=context.response_json
    matchingNodes=[]
    found_match=False
    for node in results["knowledge_graph"]["nodes"]:
        if field not in node:
            continue
        else:
            data_type=type(node[field])
            if(data_type==bool):
                if(node[field] is bool(value)):
                    matchingNodes.append(node)
            #Need to implement checks for different types.  Continues are there to appease the interpreter
            elif(data_type==str):
                continue
                #toDO
            elif(data_type==int):
                continue
                #toDo
            elif(data_type==float):
                #toDo
                continue

    for node in matchingNodes:
        if(node["id"]==id or id in node["equivalent_identifiers"]):
            found_match=True
    assert found_match
@then('the response should have some JSONPath "{json_path}" with "{data_type}" "{value}"')
def step_impl(context, json_path, data_type, value):
    """
    The response should have some JSON path with a defined value of a specified data type.

    """
    json_path_expr = jsonpath_rw.parse(json_path)
    results = json_path_expr.find(context.response_json)
    assert len(results) != 0
    if data_type == "string":
        value = str(value)
    elif data_type == "integer":
        value = int(value)
    elif data_type == "float":
        value = float(value)
    elif data_type == "boolean":
        value = eval(value)
    else:
        logging.error("Unhandled data_type: {}".format(data_type))
        assert False

    is_found = False
    for r in results:
        if r.value == value:
            is_found = True

    assert is_found is True

@then('the response should have some JSONPath "{json_path}" containing "{data_type}" "{value}"')
def step_impl(context, json_path, data_type, value):
    """
    The response should have some JSON path containing a defined value of a specified data type.

    """
    json_path_expr = jsonpath_rw.parse(json_path)
    import pprint
    pprint.pprint(context.response_json)
    results = json_path_expr.find(context.response_json)
    assert len(results) != 0
    print(data_type)
    if data_type == "string":
        value = str(value)
    elif data_type == "integer":
        value = int(value)
    elif data_type == "float":
        value = float(value)
    elif data_type == "boolean":
        value = eval(value)
    else:
        logging.error("Unhandled data_type: {}".format(data_type))
        assert False

    is_found = False
    for r in results:
        if value in r.value:
            is_found = True

    assert is_found is True
