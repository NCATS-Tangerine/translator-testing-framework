from behave import given, when, then
import json
import requests
from contextlib import closing

"""
Knowldge-source tests
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


@then('the response contains the following entries in "{key}"')
def step_impl(context, key):
    """
    This step checks whether all values specified in the test are contained in the response
    """
    entries = set()
    print('Collected entries:')
    for entry in context.response_json:
        print(' ', entry[key])
        entries.add(entry[key])
    print('Tested entries:')
    for row in context.table:
        print(' ', row[key])
        assert row[key] in entries


@then('the response contains "{value}" in "{key}"')
def step_impl(context, key, value):
    """
    This step checks whether all values specified in the test are contained in the response
    """
    entries = set()
    print('Collected entries:')
    for entry in context.response_json:
        print(' ', entry[key])
        entries.add(entry[key])
    print('Tested entry:')
    print(' ', value)
    assert value in entries


@then('the response only contains the following entries in "{key}" of "{parent}"')
def step_impl(context, key, parent):
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
        print(' ', entry[parent][key])
        assert entry[parent][key] in entries


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

