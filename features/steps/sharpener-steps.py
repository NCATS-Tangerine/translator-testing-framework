from behave import given, when, then
import requests
import json
from contextlib import closing

"""
Gene-list sharpener tests
"""

@given('a gene-list sharpener at "{url}"')
def step_impl(context, url):
    """
    Given a base URL of a gene-list sharpener
    """
    context.sharpener_url = url


@given('the gene-list sharpener')
def step_impl(context):
    """
    Given the gene-list sharpener
    """
    context.base_url = context.sharpener_url
    context.gene_list_id = None


@given('a gene list "{gene_list_str}"')
def step_impl(context, gene_list_str):
    """
        Given an input-gene-list
    """
    url = context.base_url+"/create_gene_list"
    print(url)
    gene_list = gene_list_str.split(',')
    print(gene_list)
    with closing(requests.post(url, json=gene_list, stream=False)) as response:
        response_json = response.json()
        context.gene_list_id = response_json['gene_list_id']
        assert(len(response_json['genes']) == len(gene_list))


@given('another gene list "{gene_list_str}"')
def step_impl(context, gene_list_str):
    """
        Given an input-gene-list
    """
    url = context.base_url+"/create_gene_list"
    print(url)
    gene_list = gene_list_str.split(',')
    print(gene_list)
    with closing(requests.post(url, json=gene_list, stream=False)) as response:
        response_json = response.json()
        context.gene_list_id_1 = context.gene_list_id
        context.gene_list_id_2 = response_json['gene_list_id']
        assert(len(response_json['genes']) == len(gene_list))


@when('we request the gene list')
def step_impl(context):
    url = context.base_url+'/gene_list/'+context.gene_list_id
    with closing(requests.get(url)) as response:
        context.response = response
        context.response_json = response.json()
        print(context.response_json)


@when('we call "{transformer}" transformer with the following parameters')
def step_impl(context, transformer):
    """
    This step launches a transformer
    """
    url = context.base_url+'/transform'
    print(url)
    controls = []
    values = context.table[0]
    for name in context.table.headings:
        controls.append({"name":name,"value":values[name]})
    data = {"name":transformer,"gene_list_id":context.gene_list_id, "controls":controls}
    print(data)
    with closing(requests.post(url, json=data, stream=False)) as response:
        context.response = response
        context.response_json = response.json()
        print(context.response_json)


@when('we call gene-list aggregator "{aggregator}"')
def step_impl(context, aggregator):
    """
    This step launches an aggregator
    """
    url = context.base_url+'/aggregate'
    print(url)
    data = {"operation":aggregator,"gene_list_ids":[context.gene_list_id_1,context.gene_list_id_2]}
    print(data)
    with closing(requests.post(url, json=data, stream=False)) as response:
        context.response = response
        context.response_json = response.json()
        print(context.response_json)


@then('the length of the gene list should be {size}')
def step_impl(context, size):
    """
    This step checks the size of the response gene list
    """

    print('gene list length =',len(context.response_json['genes']))
    assert len(context.response_json['genes']) == int(size)
