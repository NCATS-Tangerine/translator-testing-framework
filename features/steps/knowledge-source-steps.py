from behave import given, when, then
import json
import requests
import jsonpath_rw
import logging
from contextlib import closing

"""
Knowldege-source tests
"""


@given('a knowledge source at "{url}"')
def step_impl(context, url):
    """
    Given a base URL of a knowledge source
    """
    context.base_url = url


@when('we fire "{query}" query')
def step_impl(context, query):
    """
    Fire a knowledge-source query
    """
    url = context.base_url+query
    print('url:',url,'\n')
    with closing(requests.get(url)) as response:
        context.response = response
        context.response_json = response.json()


@when('we fire "{query}" query with the following body')
def step_impl(context, query):
    """
    Fire a knowledge-source query
    """
    url = context.base_url+query
    print('url:',url,'\n')
    with closing(requests.post(url, json=json.loads(context.text))) as response:
        context.response = response
        context.response_json = response.json()


@then('the response contains the following entries in "{key}" of "{parent}"')
def step_impl(context, key, parent):
    """
    This step checks whether all values specified in the test are contained in the response
    """
    entries = set()
    print('Collected entries:')
    for entry in context.response_json:
        print(' ', entry[parent][key])
        entries.add(entry[parent][key])
    print('Tested entries:')
    for row in context.table:
        print(' ', row[key])
        assert row[key] in entries


def _get_collected_entries(field_value):
    collected_entries = set()
    # Some fields may be a list of values
    if isinstance(field_value, list):
        for item in field_value:
            print(' ', item)
            collected_entries.add(item)
    else:  # assume a simple scalar
        print(' ', field_value)
        collected_entries.add(field_value)
    return collected_entries


def _aggregate_collected_entries(context, key):
    collected_entries = set()
    for entry in context.response_json:
        field_value = entry[key]
        [collected_entries.add(e) for e in _get_collected_entries(field_value)]
    return collected_entries


@then('the response contains the following entries in the field "{key}"')
def step_impl(context, key):
    """
    This step checks whether all values specified in the test are contained within the field of the response
    """
    print('Collected entries:')
    field_value = context.response_json[key]
    collected_entries = _get_collected_entries(field_value)

    print('Tested entries:')
    for row in context.table:
        value = row[key]
        print(' ', value)
        assert value in collected_entries


@then('some entry in the response contains "{value}" in field "{key}"')
def step_impl(context, value, key):
    """
    This step checks whether all values specified in the test are contained in the response
    """
    print('Collected entries:')
    collected_entries = _aggregate_collected_entries(context, key)

    print('Tested entry:')
    print(' ', value)
    assert value in collected_entries


@then('some entry in the response contains one of the following values in field "{key}"')
def step_impl(context, key):
    """
    This step checks whether all values specified in the test are contained in the response
    """
    print('Collected entries:')
    collected_entries = _aggregate_collected_entries(context, key)

    print('Tested entries:')
    for row in context.table:
        value = row[key]
        print(' ', value)
        assert value in collected_entries


@then('the response entries contain the following entries in the field "{key}"')
def step_impl(context, key):
    """
    This step checks whether all values specified in the test are contained within the field of the response
    """
    print('Collected entries:')
    collected_entries = _aggregate_collected_entries(context, key)

    print('Tested entries:')
    for row in context.table:
        value = row[key]
        print(' ', value)
        assert value in collected_entries


@then('the response only contains the following entries in "{key}" of "{parent}"')
def step_impl(context, key, parent):
    """
    This step checks whether all values found in the response are contained in the test table
    """
    collected_entries = set()
    print('Collected entries:')
    for row in context.table:
        field_value = row[key]
        # Some fields may be a list of values
        if isinstance(field_value, list):
            for item in field_value:
                print(' ', item)
                collected_entries.add(item)
        else:  # assume a simple scalar
            print(' ', field_value)
            collected_entries.add(field_value)

    print('Tested entries:')
    tested_entries = set()
    for entry in context.response_json:
        field_value = entry.get(parent).get(key)
        if isinstance(field_value, list):
            for item in field_value:
                tested_entries.add(item)
        else:  # assume a simple scalar
            tested_entries.add(field_value)

    for item in tested_entries:
        print(' ', item)
        assert item in collected_entries


@then('the response only contains the following entries in "{key}"')
def step_impl(context, key):
    """
    This step checks whether all values found in the response are contained in the test table
    """
    entries = set()
    print('Collected entries:')
    for row in context.table:
        print(' ', row[key])
        entries.add(row[key])
    print('Tested entries:')
    for entry in context.response_json:
        print(' ', entry[key])
        assert entry[key] in entries


@then('the size of the response is {size}')
def step_impl(context, size):
    """
    This step checks the size of the response
    """
    assert len(context.response_json) == int(size)



@then('the size of entry "{key}" is {size}')
def step_impl(context, key, size):
    """
    This step checks the size of the response
    """
    assert len(context.response_json[key]) == int(size)

@then('the response should have a field "{field}" with "{data_type}" "{value}"')
def step_impl(context, field, data_type, value):
    """
    The response should have a result with a field containing a defined value of a specified data type.
    """
    result = context.response_json
    field_expr = jsonpath_rw.parse(field)
    fields = field_expr.find(result)
    assert len(fields) != 0
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
    for f in fields:
        if f.value == value:
            is_found = True
            break

    assert is_found is True


@then('the response should have some entry with field "{field}" with "{data_type}" "{value}"')
def step_impl(context, field, data_type, value):
    """
    The response should have some entry with a field containing a defined value of a specified data type.
    """
    field_expr = jsonpath_rw.parse(field)
    for entry in context.response_json:
        results = field_expr.find(entry)
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
                break

        assert is_found is True
