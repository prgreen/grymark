exports.index = (req, res) ->
	res.render('index', { title: 'Grymark' })

exports.download = (req, res) ->
	res.render('download', { title: 'Grymark Download'})

exports.register = (req, res) ->
	res.render('register', { title: 'Grymark Registration', flash: ''})

exports.register_post = (db)->
	(req, res) ->
		#TODO more validation (size, forbidden characters)
		if req.body.password != req.body.passwordrepeat
			res.render('register', {title: 'Grymark Registration', flash: 'Passwords didn\'t match, try again!'})
		else if req.body.password == "" or req.body.passwordrepeat == "" or req.body.username == ""
			res.render('register', {title: 'Grymark Registration', flash: 'All fields are necessary!'})
		else  
			db.exists("grymark:#{req.body.username}", (err, ex)->
				if ex or err
					res.render('register', {title: 'Grymark Registration', flash: 'This username is already taken! Try another one.'})
				else
					db.set("grymark:#{req.body.username}", "#{req.body.password}", (err, res)->)
					console.log "#{req.body.username} #{req.body.password}"
					res.render('register', {title: 'Grymark Registration', flash: 'You were successfully registered! You may start using your account in Grymark!'})
			)
exports.donate = (req, res) ->
	res.render('donate', { title: 'Grymark Donations'})

exports.about = (req, res) ->
	res.render('about', { title: 'Grymark About'})

###
exports.google = (req, res) ->
	fs.readFile(__dirname + '/public/googlebcb358032381cfe6.html', 'utf8', (err, text)->
		res.send(text)
###

exports.hiscore_post = (db)->
	(req, res) ->
		#console.log "#{req.body.username} #{req.body.password} #{req.body.content}"
		db.exists("grymark:#{req.body.username}", (err, ex)->
			if err
				res.send('KO')
			else
				db.get("grymark:#{req.body.username}", (err, pass)->
					if req.body.password != pass or err
						res.send('KO')
					else
						for key,value of req.body.scores
							myloop=(k,v)->
								console.log "#{k} #{v}"
								current_key = "grymarkscore:"+k
								console.log "treating #{current_key}"
								db.exists(current_key, (err, ex)->
									if err
										console.log "ERROR checking key existence"
									else if not ex
										console.log "CREATING #{current_key}"
										db.set(current_key, v, (err)->)
									else
										db.get(current_key, (err, score)->
											if err
												console.log "ERROR getting key"
											else
												console.log "FOUND #{score} for #{current_key}"
												if v < parseInt(score, 10)
													db.set(current_key, v, (err)->)
										)
								)
							myloop(key, value)
						res.send("OK")
				)
		)

exports.hiscore = (db)->
	(req, res)->
		db.exists("grymarkscore:#{req.params.id}", (err, ex)->
			if err or not ex
				res.send("KO")
			else
				db.get("grymarkscore:#{req.params.id}", (err, score)->
					if err
						console.log "ERROR retrieving score"
						res.send("KO")
					else
						res.send(score)
				)
		)
		