fs = require "fs"
req = require "request"
async = require "async"


req "http://localhost:9200/imported/experiment/_search?size=10000", (err, res, body) ->
	body = JSON.parse body
	docs = body.hits.hits

	console.log "docs found: #{docs.length}"
	output = []
	analyzers = ["standard_stem_analyzer", "standard_snowball_analyzer", "whitespace_stem_analyzer"]

	toAnalyze = {}
	for doc in docs
		for param in doc._source.params
			toAnalyze[param.valueString] = yes if param.valueString
			for a in param.attributes
				toAnalyze[a.value] = yes if a.value

	console.log "will analyze: #{Object.keys(toAnalyze).length}"
	console.log toAnalyze
	tasks = []

	for val, trash of toAnalyze
		do (val) ->
			analyzers.forEach (analyzer) ->
				r =
					url: "http://localhost:9200/imported/_analyze?analyzer=#{analyzer}"
					method: "get"
					body: val
				tasks.push (cb) ->
					req r, (err, res, body) ->
						body = JSON.parse body
						tokens = []
						tokens.push t.token for t in body.tokens
						output.push {source: val, analyzer: analyzer, tokens: tokens}
						cb()

	console.log "tasks: #{tasks.length}"
	async.parallel tasks, (err, res)->
		console.log "done"
		fs.writeFileSync "out.json", JSON.stringify output, null, 2




