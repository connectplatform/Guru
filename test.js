var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var assert = require('assert')

console.log('\n===========');
console.log('    mongoose version: %s', mongoose.version);
console.log('========\n\n');

var dbname = 'testing_1218';
console.log('dbname: %s', dbname);
mongoose.connect('localhost', dbname);
mongoose.connection.on('error', function () {
  console.error('connection error', arguments);
});

var schema = new Schema({
    name: String
});
schema.path('_id').get(function (v) {
  return String(v);
})

var A = mongoose.model('A', schema);
mongoose.set('debug', true);

mongoose.connection.on('open', function () {
  A.create({ name: '1218' }, function (err, a) {
    if (err) return done(err);
    console.error('found:', a);
    console.log('arg type:', typeof a._id); // string
    assert(typeof a._id === 'string'); // string
    done(err);
  });
});

function done (err) {
  if (err) console.error(err.stack);
  mongoose.connection.db.dropDatabase(function () {
    mongoose.connection.close();
  });
}
