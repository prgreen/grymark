// Generated by CoffeeScript 1.6.1
(function() {

  exports.index = function(req, res) {
    return res.render('index', {
      title: 'Grymark'
    });
  };

  exports.download = function(req, res) {
    return res.render('download', {
      title: 'Grymark Download'
    });
  };

  exports.register = function(req, res) {
    return res.render('register', {
      title: 'Grymark Registration',
      flash: ''
    });
  };

  exports.register_post = function(db) {
    return function(req, res) {
      if (req.body.password !== req.body.passwordrepeat) {
        return res.render('register', {
          title: 'Grymark Registration',
          flash: 'Passwords didn\'t match, try again!'
        });
      } else if (req.body.password === "" || req.body.passwordrepeat === "" || req.body.username === "") {
        return res.render('register', {
          title: 'Grymark Registration',
          flash: 'All fields are necessary!'
        });
      } else {
        return db.exists("grymark:" + req.body.username, function(err, ex) {
          if (ex || err) {
            return res.render('register', {
              title: 'Grymark Registration',
              flash: 'This username is already taken! Try another one.'
            });
          } else {
            db.set("grymark:" + req.body.username, "" + req.body.password, function(err, res) {});
            console.log("" + req.body.username + " " + req.body.password);
            return res.render('register', {
              title: 'Grymark Registration',
              flash: 'You were successfully registered! You may start using your account in Grymark!'
            });
          }
        });
      }
    };
  };

  exports.donate = function(req, res) {
    return res.render('donate', {
      title: 'Grymark Donations'
    });
  };

  exports.about = function(req, res) {
    return res.render('about', {
      title: 'Grymark About'
    });
  };

  /*
  exports.google = (req, res) ->
  	fs.readFile(__dirname + '/public/googlebcb358032381cfe6.html', 'utf8', (err, text)->
  		res.send(text)
  */


  exports.hiscore_post = function(db) {
    return function(req, res) {
      return db.exists("grymark:" + req.body.username, function(err, ex) {
        if (err) {
          return res.send('KO');
        } else {
          return db.get("grymark:" + req.body.username, function(err, pass) {
            var key, myloop, value, _ref;
            if (req.body.password !== pass || err) {
              return res.send('KO');
            } else {
              _ref = req.body.scores;
              for (key in _ref) {
                value = _ref[key];
                myloop = function(k, v) {
                  var current_key;
                  console.log("" + k + " " + v);
                  current_key = "grymarkscore:" + k;
                  console.log("treating " + current_key);
                  return db.exists(current_key, function(err, ex) {
                    if (err) {
                      return console.log("ERROR checking key existence");
                    } else if (!ex) {
                      console.log("CREATING " + current_key);
                      return db.set(current_key, v, function(err) {});
                    } else {
                      return db.get(current_key, function(err, score) {
                        if (err) {
                          return console.log("ERROR getting key");
                        } else {
                          console.log("FOUND " + score + " for " + current_key);
                          if (v < parseInt(score, 10)) {
                            return db.set(current_key, v, function(err) {});
                          }
                        }
                      });
                    }
                  });
                };
                myloop(key, value);
              }
              return res.send("OK");
            }
          });
        }
      });
    };
  };

  exports.hiscore = function(db) {
    return function(req, res) {
      return db.exists("grymarkscore:" + req.params.id, function(err, ex) {
        if (err || !ex) {
          return res.send("KO");
        } else {
          return db.get("grymarkscore:" + req.params.id, function(err, score) {
            if (err) {
              console.log("ERROR retrieving score");
              return res.send("KO");
            } else {
              return res.send(score);
            }
          });
        }
      });
    };
  };

}).call(this);
