from behave import *
from SPARQLWrapper import SPARQLWrapper, JSON, XML, CSV, TSV
import numpy as np

"""
Given the dataset "https://w3id.org/data2services/graph/biolink/drugbank"
When we get the entity "http://identifiers.org/drugbank:DB00001"
Then its property "bl:name" should be "Lepirudin"
"""


@given('the entity "{entityUri}" in the dataset "{graphUri}"')
def step_impl(context, entityUri, graphUri):
    context.entityUri = entityUri
    context.graphUri = graphUri


@when('we ask for the property "{property}"')
def step_impl(context, property):
    context.property = property


# Run SPARQL to get the value of the required property
@then('we get the answer "{value}"')
def step_impl(context, value):

    sparql = SPARQLWrapper("http://graphdb.dumontierlab.com/repositories/ncats-red-kg")
    query = """
    PREFIX bl: <http://w3id.org/biolink/vocab/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX dct: <http://purl.org/dc/terms/>
    PREFIX dctypes: <http://purl.org/dc/dcmitype/>
    PREFIX idot: <http://identifiers.org/idot/>
    PREFIX dcat: <http://www.w3.org/ns/dcat#>
    PREFIX void: <http://rdfs.org/ns/void#>
    PREFIX void-ext: <http://ldf.fi/void-ext#>
    SELECT ?propertyValue
    WHERE {
        GRAPH <%s> {
            <%s> %s ?propertyValue .
        }
    }
    """
    sparql.setQuery(query % (context.graphUri, context.entityUri, context.property))
    sparql.setReturnFormat(JSON)

    results = sparql.query().convert()
    print(results["results"]["bindings"])
    
    # This loop doesn't work. Even if print shows that results["results"]["bindings"] is a list
    # Tried to cast it to Array using numpy np.asarray(myList), but still not working
    # If anyone can find why Python can't do a for loop on an array I would be interested.
    # See SPARQL example here: https://rdflib.github.io/sparqlwrapper/
    for result in np.asarray(results["results"]["bindings"]):
        print("we don't get into this loop!")
    # for i in range(len(results["results"]["bindings"])):

    # We get the first answer directly from array index because loop won't work
    assert value == results["results"]["bindings"][0]["propertyValue"]["value"]
