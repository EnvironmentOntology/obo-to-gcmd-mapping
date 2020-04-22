GCMD = inputs/gcmd.rdf
OBO = http://purl.obolibrary.org/obo

all: mappings

ONTS = envo pato

mappings: $(patsubst %, target/gcmd-to-%.tsv, $(ONTS))

$(GCMD):
	curl -L -s 'https://gcmdservices.gsfc.nasa.gov/kms/concepts/concept_scheme/sciencekeywords/?format=rdf' > $@
.PRECIOUS: $(GCMD)

target/%.owl:
	curl -L -s $(OBO)/$*.owl > $@.tmp && mv $@.tmp $@
.PRECIOUS: target/%.owl

# TODO: use SSSOM
target/gcmd-to-%.tsv: target/%.owl
	rdfmatch --prefix GCMD -f tsv -l -i prefixes.ttl -i $(GCMD) -i $< -G target/gcmd-to-$*.ttl match > $@.tmp && mv $@.tmp $@

# TODO: boomer
