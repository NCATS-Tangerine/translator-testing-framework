from behave import given, when, then

from ncats.translator.identifiers import object_id

from ncats.translator.modules.disease.gene.disease_associated_genes import DiseaseAssociatedGeneSet
from ncats.translator.modules.gene.gene.functional_similarity import FunctionallySimilarGenes
from ncats.translator.modules.gene.gene.phenotype_similarity import PhenotypicallySimilarGenes
from ncats.translator.modules.gene.gene.gene_interaction import GeneInteractionSet
from ncats.translator.modules.gene.gene.gene_to_gene_bicluster_RNAseqDB import GeneToGeneRNASeqDbBiclusters
from ncats.translator.modules.gene.gene.gene_to_gene_bicluster_DepMap import GeneToGeneDepMapBiclusters
from ncats.translator.modules.gene.chemical_substance.gene_to_chemical_interaction import GeneToChemicalInteractionPayload
from ncats.translator.modules.chemical_substance.gene.chemical_to_gene_interaction import ChemicalToGeneInteractionPayload


@given('the disease identifier "{disease_identifier}" for disease label "{disease_label}" in Translator Modules')
def step_impl(context, disease_identifier, disease_label):
    print('Given disease identifier '+disease_identifier+' for disease label '+disease_label)
    context.module_input_parameters = {"disease_identifier": disease_identifier, "disease_label": disease_label}


@given('the Translator Modules input "{input_type}" "{identifiers}"')
def step_impl(context, input_type, identifiers):

    print('Given input_'+input_type+'s identifiers: '+identifiers)

    # We assume that the input_parameters variable is first set here
    context.module_input_parameters = {"input_"+input_type+"s": identifiers.split(",")}


@given('the following Translator Modules input "{input_type}" identifiers')
def step_impl(context, input_type):

    print('Given following Translator Modules input_'+input_type+'s identifiers:')

    identifiers = set()
    for row in context.table:
        print(row['identifier'])
        identifiers.add(row['identifier'])

    # We assume that the input_parameters variable is first set here
    context.module_input_parameters = {"input_"+input_type+"s": identifiers}


@given('module parameters "{parameters}"')
def step_impl(context, parameters):

    print('Given module parameters: '+parameters)

    # separate comma delimited parameters into list
    parameter_list = parameters.split(",")

    # convert parameter list into a named parameter dictionary
    parameter_dict = {k: v for (k, v) in [p.split(":") for p in parameter_list]}

    # Assume here that parameters are appended to Behave step context.module_input_parameters set in a
    # previously called step, e.g. @given('the Translator Modules input "{input_type}" "{identifiers}"')
    context.module_input_parameters.update(parameter_dict)


# catalog of package/modules in translator-modules/ncats/translator/modules/
_translator_modules = {
    "Disease Associated Genes": DiseaseAssociatedGeneSet,  # disease/gene/
    "Functional Similarity": FunctionallySimilarGenes,  # gene/gene
    "Phenotype Similarity": PhenotypicallySimilarGenes,  # gene/gene
    "Gene Interaction": GeneInteractionSet,  # gene/gene
    "Gene to Gene Bicluster RNAseqDB": GeneToGeneRNASeqDbBiclusters,  # gene/gene
    "Gene to Gene Bicluster DepMap": GeneToGeneDepMapBiclusters,  # gene/gene
    "Chemical to Gene Interaction": ChemicalToGeneInteractionPayload,  # chemical_substance/gene
    "Gene to Chemical Interaction": GeneToChemicalInteractionPayload,  # gene/chemical_substance
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
    module = payload(**context.module_input_parameters)
    context.results = module.results[['hit_id', 'hit_symbol']].to_dict(orient='records')


@then('the Translator Module result contains "{input_type}" identifiers "{target_identifiers}"')
def step_impl(context, input_type, target_identifiers):

    print('Then the Translator Module result should contain '+input_type+' identifiers '+target_identifiers)

    hit_ids = set([x["hit_id"] for x in context.results])

    target_identifiers = target_identifiers.split(",")

    for identifier in target_identifiers:
        print('Assessing identifier: '+identifier)
        assert identifier in hit_ids


@then('the Translator Module result contains the following "{input_type}" identifiers')
def step_impl(context, input_type):

    print('Then the Translator Module result contains the following '+input_type+' identifiers:')

    # Only attempt exact match on the core object_id, without xmlns prefix and version
    hit_ids = set([object_id(x["hit_id"]) for x in context.results])

    target_identifiers = set()
    for row in context.table:
        print(row['identifier'])
        target_identifiers.add(row['identifier'])

    for identifier in target_identifiers:
        print('Assessing identifier: '+identifier)
        assert object_id(identifier) in hit_ids


@then('the Translator Module result contains gene symbols "{gene_symbols}"')
def step_impl(context, gene_symbols):
    print('Then the Translator Module result should contain gene symbols '+gene_symbols)
    hit_symbols = set([x["hit_symbol"] for x in context.results if isinstance(x, dict)])
    gene_symbols = gene_symbols.split(",")
    for symbol in gene_symbols:
        print('Assessing symbol: ' + symbol)
        assert symbol in hit_symbols
