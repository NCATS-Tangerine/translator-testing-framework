Feature: Check MyVariant.info response

  Scenario: return dbsnp id given a myvariant hgvs id
    Given a valid variant hgvs id "chr6:g.42454850G>A"
      When we query myvariant.info API using this variant hgvs id
      Then we expect the dbsnp id to be "rs12190874"