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
from resources.questions import question_map, fill_template


"""
Given
"""
@given('a valid entrez gene id "{gene_id}"')
def step_impl(context, gene_id):
    context.gene_id = gene_id


@when('we query mygene.info API using this gene id')
def step_impl(context):
    url = 'http://mygene.info/v3/gene/{}?fields=symbol'.format(context.gene_id)
    data = requests.get(url)
    context.response = data

@then('we expect gene symbol is returned for this gene id')
def step_impl(context):
    assert 'symbol' in context.response.json()

@given('the TranQL query')
def step_impl(context):
    """
    Fetch answer from TranQL query.
    """
    context.tranql_query = context.text

@given('a question "{question_type}"')
def step_impl(context, question_type):
    context.question = question_map[question_type]

@given('node mappings')
def step_impl(context):
    node_mappings = json.loads(context.text)
    context.question = fill_template(context.question, node_mappings)

@given('the "{language}" question "{question}"')
def step_impl(context, language, question):
    context.human_question = {
        "language": language,
        "text": question
    }

@given('the machine question')
def step_impl(context):
    context.machine_question = json.loads(context.text)

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

@given('identifier {ident} and type {stype}')
def step_impl(context,ident,stype):
    context.identifier = ident
    context.semantic_type = stype


"""
When
"""

@when('we call synonymizer')
def step_impl(context):
    url=f'http://robokop.renci.org:6010/api/synonymize/{context.identifier}/{context.semantic_type}/'
    response = requests.post(url)
    context.response = response
    context.response_json = response.json()
    print(context.response_json)

@when('we fire the query to TranQL we expect a HTTP "{status_code:d}"')
def step_impl(context, status_code):
    """
    Fire a query to TranQL
    """

    url = context.tranql_url
    with closing(requests.post(url, json={"query":context.tranql_query}, stream=False)) as response:
        context.code = response.status_code
        context.content_type = response.headers['content-type']
        assert response.status_code == status_code
        context.response_text = response.text
        context.response_json = response.json()

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
        assert response.status_code == status_code
        context.response_text = response.text
        context.response_json = response.json()

@when('we fire the query to URL "{url}"')
def step_impl(context, url ):
    """
    Fire a query stored in the context to a reasoner.
    """
    with closing(requests.post(url,json=context.question)) as response:
        context.code = response.status_code
        context.content_type = response.headers['content-type']
        context.response = response
        context.response_json = response.json()


@when('we send the question to RTX')
def step_impl(context):
    """
    This step sends a query (stored in context.machine_question) to RTX, makes sure that the server returns a 200
    status code, and stores the response in context. If the question has been provided in human language format (in
    context.human_question), it first sends that to RTX for translation into a machine question.
    """
    rtx_api_url = "https://rtx.ncats.io/api/rtx/v1"
    rtx_headers = {'accept': 'application/json'}

    # First translate the natural language question, if there is one
    if hasattr(context, 'human_question'):
        translate_response = requests.post(rtx_api_url + "/translate", json=context.human_question, headers=rtx_headers)
        context.content_type = translate_response.headers['content-type']
        assert translate_response.status_code == 200
        context.machine_question = translate_response.json()

    # Then query RTX with the translated question
    query_response = requests.post(rtx_api_url + "/query", json=context.machine_question, headers=rtx_headers)
    context.code = query_response.status_code
    context.content_type = query_response.headers['content-type']
    assert query_response.status_code == 200
    context.response_text = query_response.text
    context.response_json = query_response.json()


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

@then('we expect a HTTP "{value:d}"')
def step_impl(context,value):
    assert context.response.status_code == value

@then('the response should contain "{value}"')
def step_impl(context, value):
    """ 
    Check if the response contains a given string.

    """
    assert context.response_text.rfind(value) != -1


@then('the answer graph should include node "{node}"')
def step_impl(context, node):
    """
    This step checks to see if a particular node is present in a reasoner's answer knowledge graph. The 'node' parameter
    consists of a CURIE id, optionally followed by a node name in parentheses (e.g., 'UniProtKB:P00439 (PAH)'); anything
    in parentheses is removed prior to processing.
    """
    node_id = node.partition("(")[0].strip()  # Extract node ID from what was passed in
    nodes = context.response_json["knowledge_graph"]["nodes"]
    node_found = any(node['id'] == node_id for node in nodes)
    assert node_found


@then('the results should include node "{node}" with similarity value > {min_expected_value:f}')
def step_impl(context, node, min_expected_value):
    """
    This step checks to see if a particular node has been returned as a result from a reasoner with a similarity value
    value above a specified threshold. The 'node' parameter consists of a CURIE id, optionally followed by a node name
    in parentheses (e.g., 'UniProtKB:P00439 (PAH)'); anything in parentheses is removed prior to processing.
    """
    node_id = node.partition("(")[0].strip()  # Extract node ID from what was passed in
    results = context.response_json["results"]
    relevant_result = next((result for result in results if result['row_data'][3] == node_id), None)
    assert relevant_result is not None
    similarity_value = relevant_result['confidence']
    assert similarity_value > min_expected_value


@then('the answer graph should contain the following nodes')
def step_impl(context):
    """
    This step checks to see if a list of ground truth nodes (provided in table format in the .feature file) are all
    present in a reasoner's answer knowledge graph. The input table must have an 'id' column with CURIE ids.
    """
    response_nodes = context.response_json["knowledge_graph"]["nodes"]
    for row in context.table:
        node_found = any(node['id'] == row['id'] for node in response_nodes)
        assert node_found


@then('the answer graph should contain the following relationships')
def step_impl(context):
    """
    This step takes in a list of edges (provided in table format) and checks to see if they are present in a reasoner's
    answer knowledge graph. The input table must have 'source_id' and 'target_id' columns with CURIE ids.
    """
    response_edges = context.response_json["knowledge_graph"]["edges"]
    for row in context.table:
        edge_found = any(edge['source_id'] == row['source_id']
                         and edge['target_id'] == row['target_id']
                         and edge['type'] == row['edge_type'] for edge in response_edges)
        assert edge_found


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
    The response should have some JSON path containing a defined value of a specified data type.

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

@then('we expect the main identifier to be {identifier}')
def step_impl(context,identifier):
    assert context.response_json['id'] == identifier

@then('we expect the name to be "{name}"')
def step_impl(context,name):
    assert context.response_json['name'] == name

@then('we expect the equivalent identifiers to contain {identifier}')
def step_impl(context,identifier):
    syns = [ x[0] for x in context.response_json['synonyms'] ]
    assert identifier in syns

@then('we do not expect the equivalent identifiers to contain {identifier}')
def step_impl(context,identifier):
    syns = [ x[0] for x in context.response_json['synonyms'] ]
    assert not identifier in syns


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
