import requests

"""
Given
"""
@given('a valid entrez gene id "{gene_id}"')
def step_impl(context, gene_id):
    context.gene_id = gene_id

@given('a valid variant hgvs id "{hgvsid}"')
def step_impl(context, hgvsid):
    context.hgvsid = hgvsid

@given('a valid chemical ChEMBL id "{chembl}"')
def step_impl(context, chembl):
    context.chembl = chembl

@given('a valid disease MONDO id "{mondo}"')
def step_impl(context, mondo):
    context.mondo = mondo

"""
When
"""
@when('we query mygene.info API using this gene id')
def step_impl(context):
    url = 'http://mygene.info/v3/gene/{}?fields=symbol'.format(context.gene_id)
    data = requests.get(url)
    context.response = data

@when('we query myvariant.info API using this variant hgvs id')
def step_impl(context):
    url = 'http://myvariant.info/v1/variant/{}?fields=dbsnp.rsid'.format(context.hgvsid)
    data = requests.get(url)
    context.response = data

@when('we query mychem.info API using this chemical ChEMBL id')
def step_impl(context):
    url = 'http://mychem.info/v1/chem/{}?fields=chembl.pref_name'.format(context.chembl)
    data = requests.get(url)
    context.response = data

@when('we query mydisease.info API using this disease MONDO id')
def step_impl(context):
    url = 'http://mydisease.info/v1/disease/{}?fields=mondo.xrefs.doid'.format(context.mondo)
    data = requests.get(url)
    context.response = data

"""
Then
"""
@then('we expect the symbol to be "{symbol}"')
def step_impl(context, symbol):
    assert symbol == context.response.json()['symbol']

@then('we expect the dbsnp id to be "{rsid}"')
def step_impl(context, rsid):
    assert rsid == context.response.json()['dbsnp']['rsid']

@then('we expect the chemical name to be "{name}"')
def step_impl(context, name):
    assert name == context.response.json()['chembl']['pref_name']

@then('we expect the disease ontology ID to be "{doid}"')
def step_impl(context, doid):
    assert doid == context.response.json()['mondo']['xrefs']['doid']