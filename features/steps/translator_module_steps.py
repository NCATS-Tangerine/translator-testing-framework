from behave import given, when, then
from ncats.translator.modules.disease.gene.disease_associated_genes import DiseaseAssociatedGeneSet
from ncats.translator.modules.gene.gene.functional_similarity import FunctionallySimilarGenes
from ncats.translator.modules.gene.gene.phenotype_similarity import PhenotypicallySimilarGenes
from ncats.translator.modules.gene.gene.gene_interaction import GeneInteractionSet


@given('the disease identifier "{disease_identifier}" for disease label "{disease_label}" in Translator Modules')
def step_impl(context, disease_identifier, disease_label):
    print('Given disease identifier '+disease_identifier+' for disease label '+disease_label)
    context.input_parameters = {"disease_identifier": disease_identifier, "disease_label": disease_label}


@given('the Translator Modules input "{type}" "{identifiers}"')
def step_impl(context, type, identifiers):
    print('Given input_'+type+' identifiers: '+identifiers)
    context.input_parameters = {"input_"+type: identifiers.split(",")}


# catalog of package/modules in translator-modules/ncats/translator/modules/
_translator_modules = {
    "Disease Associated Genes": DiseaseAssociatedGeneSet,  # disease/gene/
    "Functional Similarity": FunctionallySimilarGenes,  # gene/gene
    "Phenotype Similarity": PhenotypicallySimilarGenes,  # gene/gene
    "Gene Interaction": GeneInteractionSet,  # gene/gene
}


@when('we run the Translator "{module}" Module')
def step_impl(context, module):
    print('When running the '+module+' Translator Module')
    if module in _translator_modules.keys():
        payload = _translator_modules[module]
    else:
        assert False

    # The 'payload' is a class whose initialization
    # will run the module on the specified input data
    module = payload(**context.input_parameters)
    context.results = module.results[['hit_id', 'hit_symbol']].to_dict(orient='records')


@then('the Translator Module result contains "{gene_ids}"')
def step_impl(context, gene_ids):
    print('Then the Translator Module result should contain gene identifiers '+gene_ids)
    hit_ids = [x["hit_id"] for x in context.results]
    gene_ids = gene_ids.split(",")
    for gene in gene_ids:
        assert gene in hit_ids
