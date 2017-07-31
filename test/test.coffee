chai = require 'chai'
expect = chai.expect

merge = require '../'


describe 'Merge', ->
	it 'add keys that do not exist elsewhere', ->
		o = {}
		a = {}
		b =
			key1: 'value1'
			key2: 'value2'
		expected =
			key1: 'value1'
			key2: 'value2'

		expect(expected).to.deep.equal merge(o, a, b)


	it 'existing simple keys', ->
		o =
			key1: 'value1'
		a =
			key1: 'changed'
			key2: 'value2'
		b =
			key1: 'value1'
			key3: 'value3'
		expected =
			key1: 'changed'
			key2: 'value2'
			key3: 'value3'

		expect(expected).to.deep.equal merge(o, a, b)


	it 'existing nested objects', ->
		o =
			key1:
				subkey1: 'value1'
		a =
			key1:
				subkey1: 'changed'
				subkey2: 'value2'
		b =
			key1:
				subkey1: 'value1'
				subkey3: 'value3'
		expected =
			key1:
				subkey1: 'changed'
				subkey2: 'value2'
				subkey3: 'value3'

		expect(expected).to.deep.equal merge(o, a, b)


	it 'replace simple key with nested object', ->
		o = {}
		a =
			key1: 'value1'
			key2: 'value2'
		b =
			key1:
				subkey1: 'value1'
				subkey2: 'value2'
		expected =
			key1:
				subkey1: 'value1'
				subkey2: 'value2'
			key2: 'value2'

		expect(expected).to.deep.equal merge(o, a, b)


	it 'add nested object', ->
		o = {}
		a =
			a: {}
		b =
			b:
				c: {}
		expected =
			a: {}
			b:
				c: {}

		expect(expected).to.deep.equal merge(o, a, b)


	it 'replace object with simple key', ->
		o =
			key1:
				subkey1: 'value1'
				subkey2: 'value2'
			key2: 'value2'
		a =
			key1: 'value1'
			key2: 'value2'
		b =
			key1: 'value1'

		expected =
			key1: 'value1'

		expect(expected).to.deep.equal merge(o, a, b)


	it 'on array properties', ->
		o = {}
		a =
			key1: ['one', 'two']
		b =
			key1: ['one', 'three']
			key2: ['four']
		expected =
			key1: ['one', 'two', 'three']
			key2: ['four']

		expect(expected).to.deep.equal merge(o, a, b)


	it 'on array of objects', ->
		o = {}
		a = [
			{ key1: ['one', 'two'] }
			{ key3: ['four'] }
		]

		b = [
			{ key1: ['one', 'three'], key2: ['one'] }
			{ key3: ['five'] }
		]

		expected = [
			{ key1: ['one', 'two', 'three'], key2: ['one'] }
			{ key3: ['four', 'five'] }
		]

		expect(expected).to.deep.equal merge(o, a, b)


	it 'on arrays of nested objects', ->
		o = [
			{ key1: { subkey: 'two'} }
		]
		a = [
			{ key1: { subkey: 'one' } }
		]
		b = [
			{ key1: { subkey: 'two' } }
			{ key2: { subkey: 'three'} }
		]
		expected = [
			{ key1: { subkey: 'one' } }
			{ key2: { subkey: 'three'} }
		]

		expect(expected).to.deep.equal merge(o, a, b)


	it 'delete in array and collision add', ->
		o = ['one', 'two']
		a = ['one', 'two', 'three']
		b = ['one']
		expected = ['one', 'three']

		expect(expected).to.deep.equal merge(o, a, b)

	it 'null values in object', ->
		o = key1: null
		a = key1: key2: null
		b = key1: null
		expected = key1: key2: null

		expect(expected).to.deep.equal merge(o, a, b)

	it 'throws error when merging is impossible', ->
		o = 'o'
		a = 'a'
		b = 'b'

		expect(-> merge o, a, b).to.throw Error

	it 'arrays and sort', ->
		o = [0, 1, 2, 3]
		a = [0, 1, 2, 30]
		b = [0, 10, 2, 3]
		expected = [0, 2, 10, 30]

		expect(expected).to.deep.equal merge(o, a, b)
