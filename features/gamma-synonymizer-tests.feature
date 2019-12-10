Feature: Check ROBOKOP synonymizer

    Scenario: Synonymizing diseases from MONDO
        Given identifier MONDO:0005737 and type disease
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be MONDO:0005737
        And we expect the equivalent identifiers to contain DOID:4325
        And we expect the equivalent identifiers to contain ORPHANET:319218
        And we expect the equivalent identifiers to contain MESH:D019142
        And we expect the equivalent identifiers to contain UMLS:C0282687

    Scenario: Synonymizing diseases from UMLS
        Given identifier UMLS:C0282687 and type disease
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be MONDO:0005737
        And we expect the equivalent identifiers to contain DOID:4325
        And we expect the equivalent identifiers to contain ORPHANET:319218
        And we expect the equivalent identifiers to contain MESH:D019142
        And we expect the equivalent identifiers to contain UMLS:C0282687

    Scenario: Synonymizing chemicals from MeSH
        Given identifier MeSH:D014867 and type chemical_substance
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be CHEBI:15377
        And we expect the equivalent identifiers to contain DRUGBANK:DB09145
        And we expect the equivalent identifiers to contain PUBCHEM:22247451
        And we expect the equivalent identifiers to contain CHEMBL:CHEMBL1098659
        And we expect the equivalent identifiers to contain HMDB:HMDB0002111
        And we expect the equivalent identifiers to contain PUBCHEM:962
        And we expect the equivalent identifiers to contain KEGG.COMPOUND:C00001

    Scenario: Synonymizing is not case sensitive
        Given identifier mEsh:D014867 and type chemical_substance
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be CHEBI:15377
        And we expect the equivalent identifiers to contain DRUGBANK:DB09145
        And we expect the equivalent identifiers to contain PUBCHEM:22247451
        And we expect the equivalent identifiers to contain CHEMBL:CHEMBL1098659
        And we expect the equivalent identifiers to contain HMDB:HMDB0002111
        And we expect the equivalent identifiers to contain PUBCHEM:962
        And we expect the equivalent identifiers to contain KEGG.COMPOUND:C00001

    Scenario: Synonymizing is type-specific (superclass)
        Given identifier EFO:0000249 and type disease_or_phenotypic_feature
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be MONDO:0004975
        And we expect the equivalent identifiers to contain HP:0002511

    Scenario: Synonymizing is type-specific (disease)
        Given identifier EFO:0000249 and type disease
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be MONDO:0004975
        And we do not expect the equivalent identifiers to contain HP:0002511

    Scenario: Synonymizing is type-specific (phenotype)
        Given identifier EFO:0000249 and type phenotypic_feature
        When we call synonymizer 
        Then we expect a HTTP "200"
        And we expect the main identifier to be HP:0002511
        And we do not expect the equivalent identifiers to contain MONDO:0004975
