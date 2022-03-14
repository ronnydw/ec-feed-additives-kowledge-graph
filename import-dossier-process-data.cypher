LOAD CSV WITH HEADERS FROM 'file:///tbl2-Applications.csv' AS row FIELDTERMINATOR ';'
MERGE (a:Application {sequence: row.applicSequence, additive: row.applicAdditive_name})
MERGE (add:Additive {name: row.applicAdditive_name} )
MERGE (f:Applicant {id: row.applicApplicantNum} )
MERGE (a)-[radd:FOR_ADDITIVE]->(add)
MERGE (a)-[rapp:BY_APPLICANT]->(f)
WITH row
WHERE row.applicApplicDate IS NOT NULL
MERGE (a:Application {applicationDate: row.applicApplicDate})
WITH row
WHERE row.finishedDate IS NOT NULL
MERGE (a:Application {finishedDate: row.applicFinishedDate})
WITH row
WHERE row.aplicTrade_name IS NOT NULL
MERGE (add:Additive {tradeName: row.applicTrade_name});

## The data for the app should be located at:
## ~/Library/Application Support/Neo4j Desktop/

MATCH (add:Additive)<-[radd:FOR_ADDITIVE]-(a:Application)-[rapp:BY_APPLICANT]->(app:Applicant)
WHERE a.sequence > 3120
RETURN (add)<-[radd]-(a)-[rapp]->(app)

LOAD CSV WITH HEADERS FROM 'file:///tbl2b-Applic_AnimalSpecies1.csv' AS row FIELDTERMINATOR ';'
MERGE (s:Species {speciesLib: row.rAnispc_Lib})
MERGE (a:Application {sequence: row.as_applic_sequence})
MERGE (a)-[radd:FOR_SPECIES]->(s)

match (a:Application)-[:FOR_SPECIES]->(s:Species)
WHERE s.speciesLib <> '-' AND s.speciesLib <> 'All animal species'
RETURN a,s

LOAD CSV WITH HEADERS FROM 'file:///rAnimal_Spec_Query.csv' AS row FIELDTERMINATOR ';'
MERGE (cat:SpeciesCategory {speciesLib: row.rAnispec_Cat})
MERGE (s:Species {speciesLib: row.rAnispc_Lib})
MERGE (s)-[rcat:OF_CATEGORY]->(cat)

match (a:Application)-[:FOR_SPECIES]->(s:Species)-[:OF_CATEGORY]->(cat:SpeciesCategory)
RETURN a,s,cat

LOAD CSV WITH HEADERS FROM 'file:///tbl2c-Applic_Catsub-Query.csv' AS row FIELDTERMINATOR ';'
MERGE (af:AdditiveFunction {functionGroup: row.rCfsFunc_group, category: row.rCfsCategory})
MERGE (a:Application {sequence: row.cs_applic_sequence})
MERGE (a)-[:FUNCTION]->(af)

LOAD CSV WITH HEADERS FROM 'file:///tbl2g-Applic_Many_additives.csv' AS row FIELDTERMINATOR ';'
MERGE (ma:ManyAdditive {name: row.maAdditive_name})
MERGE (a:Application {sequence: row.ma_applic_sequence})
MERGE (ma)-[:MANY_FOR]->(a)

match(ma:ManyAdditive)-[]->(a:Application)-[:FUNCTION|:FOR_ADDITIVE]->(n)
RETURN ma,a,n
