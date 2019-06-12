from behave import given, when, then, step
import requests, jsonpath_rw
from contextlib import closing
import logging
from reasoner_diff.test_rtx import answer as rtx_answer
from reasoner_diff.test_robokop import answer as robokop_answer

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
        with closing(requests.get(url, stream=False)) as response:
            context.code = response.status_code
            context.content_type = response.headers['content-type']
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
