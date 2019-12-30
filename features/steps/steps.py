import jsonpath_rw
import logging
import requests
import json
import pandas as pd

from behave import given, when, then, use_step_matcher
from contextlib import closing
from reasoner_diff.test_robokop import answer as robokop_answer
from reasoner_diff.test_robokop import question as robokop_question
from reasoner_diff.test_robokop import headers as robokop_headers
from reasoner_diff.test_rtx import answer as rtx_answer
from resources.questions import question_map, fill_template
from parse_answer import parse_answer


"""
Given
"""


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


@given('identifiers {ident} and type {stype}')
def step_impl(context,ident,stype):
    context.identifiers = ident.split(',')
    context.semantic_type = stype


@given('a query graph with the following mappings')
def step_impl(context):
    """
    This step builds a simple single-edge query graph (intended for RTX) based on the mappings specified in the .feature
    file (in table format) and loads it into context.machine_question.
    """
    mappings = context.table[0]
    context.machine_question = {
        "message": {
            "query_graph": {
                "edges": [
                    {
                        "id": "qg2",
                        "source_id": "qg0",
                        "target_id": "qg1",
                        "type": mappings['edge_type'] if mappings['edge_type'] else None
                    }
                ],
                "nodes": [
                    {
                        "id": "qg0",
                        "type": mappings['source_type'] if mappings['source_type'] else None,
                        "curie": mappings['source_curie'] if mappings['source_curie'] else None
                    },
                    {
                        "id": "qg1",
                        "type": mappings['target_type'] if mappings['target_type'] else None,
                        "curie": mappings['target_curie'] if mappings['target_curie'] else None
                    }
                ]
            }
        },
        "max_results": 200
    }


"""
When
"""


@when('we call synonymizer')
def step_impl(context):
    url=f'http://robokop.renci.org:6010/api/synonymize/{context.identifier}/{context.semantic_type}/'
    response = requests.post(url)
    context.response = response
    context.response_json = response.json()


@when('we call gamma similarity with result type {rtype}, intermediate type {itype}, and threshold {thresh:f}')
def step_impl(context,rtype,itype,thresh):
    url=f'http://robokop.renci.org/api/simple/similarity/{context.semantic_type}/{context.identifier}/{rtype}/{itype}'
    params = {'threshhold': thresh}
    response = requests.get(url, params = params)
    context.response = response
    context.similarity_result = pd.DataFrame(response.json())


@when('we call gamma enrichment with result type {rtype}')
def step_impl(context,rtype):
    url=f'https://robokop.renci.org/api/simple/enriched/{context.semantic_type}/{rtype}/'
    params = {'identifiers': context.identifiers}
    response = requests.post(url, json = params)
    context.response = response
    df = pd.DataFrame(response.json())
    df.sort_values(by='p',inplace=True)
    context.enrichment_result = df


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
    status code, and stores the response in context. If the question has been provided in natural language format (in
    context.human_question), it first sends that to RTX for translation into a machine question.
    """
    rtx_api_url = "https://arax.rtx.ai/api/rtx/v1"
    rtx_headers = {'accept': 'application/json'}

    # First translate the natural language question, if there is one
    if hasattr(context, 'human_question'):
        translate_response = requests.post(rtx_api_url + "/translate", json=context.human_question, headers=rtx_headers)
        print(translate_response.status_code, translate_response.text)  # Only displays if test fails
        assert translate_response.status_code == 200
        context.machine_question = translate_response.json()

    # Then query RTX with the translated question
    context.machine_question["bypass_cache"] = "true"
    query_response = requests.post(rtx_api_url + "/query", json=context.machine_question, headers=rtx_headers)
    print(query_response.status_code, query_response.text)  # Only displays if test fails
    assert query_response.status_code == 200
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
    This step checks to see if a particular node is present in a reasoner's answer graph. The 'node' parameter consists
    of a CURIE id, optionally followed by a node name in parentheses (e.g., 'UniProtKB:P00439 (PAH)'); anything in
    parentheses is ignored.
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
    in parentheses (e.g., 'UniProtKB:P00439 (PAH)'); anything in parentheses is ignored.
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
    present in a reasoner's answer graph. The input table must have an 'id' column with CURIE ids.
    """
    response_nodes = context.response_json["knowledge_graph"]["nodes"]
    for row in context.table:
        node_found = any(node['id'] == row['id'] for node in response_nodes)
        if not node_found:
            print(f"Response does not include node {row['id']} ({row['name']})!")
        assert node_found


@then('the answer graph should contain the following relationships')
def step_impl(context):
    """
    This step takes in a list of edges (provided in table format) and checks to see if they are present in a reasoner's
    answer graph. The input table must have 'source_id' and 'target_id' columns with CURIE ids.
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
def step_impl(context, identifier):
    assert context.response_json['id'] == identifier


@then('we expect the name to be "{name}"')
def step_impl(context, name):
    assert context.response_json['name'] == name


@then('we expect the equivalent identifiers to contain {identifier}')
def step_impl(context,identifier):
    syns = [ x[0] for x in context.response_json['synonyms'] ]
    assert identifier in syns


@then('we do not expect the equivalent identifiers to contain {identifier}')
def step_impl(context,identifier):
    syns = [ x[0] for x in context.response_json['synonyms'] ]
    assert not identifier in syns


@then('at least {x:d} of the top {y:d} names of node {nid} should contain the text "{text}"')
def step_impl(context,x,y,nid,text):
    aframe = parse_answer(context.response_json,node_list=[f'{nid}'])
    names = aframe[0:y][f'{nid} - name'].tolist()
    n = len(list(filter(lambda x: text in x, names)))
    assert(n >= x)


@then('the top {x:d} names of node {nid} should contain "{names_string}"')
def step_impl(context,x,nid,names_string):
    aframe = parse_answer(context.response_json,node_list=[f'{nid}'])
    answernames = aframe[0:x][f'{nid} - name'].tolist()
    names = names_string.split(',')
    for name in names:
        assert name in answernames


@then('we expect the name of the most similar to be "{simname}"')
def step_impl(context,simname):
    most_similar = context.similarity_result.iloc[0]['name']
    assert most_similar == simname

@then('we expect the name of the most enriched to be "{enriched_name}"')
def step_impl(context,enriched_name):
    most_enriched = context.enrichment_result.iloc[0]['name']
    assert most_enriched == enriched_name


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


@when('the message is processed by {url}')
def call(context, url):
    """Send message to microservice."""
    request = {
        'message': {
            'query_graph': context.query_graph,
            'results': getattr(context, 'results', []),
        },
        'options': getattr(context, 'options', {})
    }
    if 'knowledge_graph' in context:
        request['message']['knowledge_graph'] = context.knowledge_graph
    context.response = requests.post(url, json=request)
    context.response_json = context.response.json()

use_step_matcher('re')

# This is much too generic a pattern matching template which
# will override any other @given in the steps.py file which starts with the English article 'a'
# so we comment it out!
#
#@given('a (?P<key>.*)')
#def append_to_list(context, key):
#   """Append element to list in context.
#
#    Create the list if it does not exist.
#    """
#    key = key.replace(' ', '_') + 's'
#    value = getattr(context, key, [])
#    value.append(json.loads(context.text))
#    setattr(context, key, value)

#
# This is much too generic a pattern matching template which
# will override practically everything other @given in the steps.py file
# so we comment it out!
#
#@given('(?P<key>.*)')
#def add_scalar(context, key):
#    """Add a scalar value to context."""
#    key = key.replace(' ', '_')
#    setattr(context, key, json.loads(context.text))


@then(
    r'the response should have '
    r'(?:(?:(?P<n2>an? |\d+ )?(?P<key2>[\w\-:]+) with )?'
    r'(?P<n1>an? |\d+ )?(?P<key1>[\w\-:]+) with )?'
    r'(?P<n0>an? |\d+ )?(?P<key0>[\w\-:]+)'
    r'(?: (?P<containing>containing )?(?P<value>[\w\-:]+))?')
def check_json(context, **kwargs):
    """Check JSON structure/value.

    e.g. 'the response should have a result with an edge_binding with weight 5'
    matches the structure
    results:
      - node_bindings: ...
        edge_bindings:
        - kg_id: ''
          qg_id: ''
          weight: 5
        - ...
      - ...
    """
    values = [context.response_json]
    for i in reversed(range(3)):
        if not kwargs[f'key{i}']:
            continue
        if kwargs[f'n{i}']:
            try:
                n = int(kwargs[f'n{i}'])
            except ValueError:
                values = [x for value in values for x in value.get(kwargs[f'key{i}'] + 's', [])]
                continue
            _values = []
            for value in values:
                x = value.get(kwargs[f'key{i}'] + 's', [])
                if len(x) != n:
                    continue
                _values.extend(x)
            values = _values
        else:
            values = [value.get(kwargs[f'key{i}'], None) for value in values]
    if kwargs['value']:
        if kwargs['containing']:
            assert any(value and type(value[0])(kwargs['value']) in value for value in values)
        else:
            assert any(value and value == type(value)(kwargs['value']) for value in values)


use_step_matcher("parse")
