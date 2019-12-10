import requests
from biothings_explorer.hint import Hint
from biothings_explorer.registry import Registry
from biothings_explorer.user_query_dispatcher import FindConnection

reg = Registry()

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

@given('a valid gene symbol "{symbol}"')
def step_impl(context, symbol):
    ht = Hint()
    gene_hint = ht.query(symbol)
    context.gene = gene_hint['Gene'][0]

@given('a valid disease named "{name}"')
def step_impl(context, name):
    ht = Hint()
    disease_hint = ht.query(name)
    context.disease = disease_hint['DiseaseOrPhenotypicFeature'][0]

@given('a valid disease "{disease}" and a valid chemical named "{chemical}"')
def step_impl(context, disease, chemical):
    ht = Hint()
    context.disease = ht.query(disease)['DiseaseOrPhenotypicFeature'][0]
    context.chemical = ht.query(chemical)['ChemicalSubstance'][0]

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

@when('we query biothings explorer for chemicals related to this gene')
def step_impl(context):
    context.fc = FindConnection(input_obj=context.gene,
                                output_obj="ChemicalSubstance",
                                intermediate_nodes=None,
                                registry=reg)
    context.fc.connect(verbose=True)

@when('we query biothings explorer for drugs that are associated with genes which are invovled in the disease')
def step_impl(context):
    context.fc = FindConnection(input_obj=context.disease,
                                output_obj="ChemicalSubstance",
                                intermediate_nodes=['Gene'],
                                registry=reg)
    context.fc.connect(verbose=True)
    print(context.fc.fc.G)

@when('we query biothings explorer to identify plausible reasoning chains to explain the relationship between two entities')
def step_impl(context):
    context.fc = FindConnection(input_obj=context.disease,
                                output_obj=context.chemical,
                                intermediate_nodes=['Gene'],
                                registry=reg)
    context.fc.connect(verbose=True)
    print(context.fc.fc.G)


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

@then('we expect "{chemical}" is one of the chemicals in the results')
def step_impl(context, chemical):
    assert chemical in context.fc.fc.G

@then('we expect gene "{gene}" is one of the explanations that may link the two entities')
def step_impl(context, gene):
    assert gene in context.fc.fc.G