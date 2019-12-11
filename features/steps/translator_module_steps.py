from behave import given, when, then
from ncats.translator.modules.disease.gene.disease_associated_genes import DiseaseAssociatedGeneSet

@given('the disease identifier "{disease_identifier}" for disease label "{disease_label}" in Translator Modules')
def step_impl(context, disease_identifier, disease_label):
    context.disease = {"disease_identifier": disease_identifier, "disease_label": disease_label}


@when('we run the disease associated genes Translator Module')
def step_impl(context):
    #translator-modules/ncats/translator/modules/disease/gene/
    
    #initialization will run the method
    context.module = \
        DiseaseAssociatedGeneSet(
            context.disease["disease_identifier"],
            context.disease["disease_label"]
        )


@then('the Translator Module result contains "{gene_ids}"')
def step_impl(context,gene_ids):
    hit_ids = [ x["hit_id"] for x in context.module.disease_associated_genes ]
    gene_ids = gene_ids.split(",")
    for gene in gene_ids:
        assert gene in hit_ids
