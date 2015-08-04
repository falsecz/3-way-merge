###
Function for 3-way merge

@param {Object} o (original)
@param {Object} a (current)
@param {Object} b (new)
@return {Object} Merged result
###

merge = (o, a, b) ->
	throw new Error 'Merge original document must be an object!' if typeof o isnt 'object'
	throw new Error 'Merge current document must be an object!' if typeof a isnt 'object'
	throw new Error 'Merge new document must be an object!' if typeof b isnt 'object'

	isArray = Array.isArray b
	result = if isArray then [] else {}

	if isArray
		a = [] if not Array.isArray a
		o = [] if not Array.isArray o

		for k of a
			unless a[k] not in b and a[k] in o
				result.push a[k]

		for k of b
			if not k of a
				result.push b[k]
			else if typeof a[k] is 'object' and typeof b[k] is 'object'
				ov = if k of o and typeof o[k] is 'object' then o[k] else {}
				result[k] = merge ov, a[k], b[k]
			else if b[k] not in a
				result.push b[k]

	else
		a = {} if Array.isArray a

		for k of b
			result[k] = b[k]

		for k of a
			if not k of result
				result[k] = a[k]
			else if a[k] isnt result[k]
				if typeof a[k] is 'object' and typeof b?[k] is 'object'
					ov = if o? and k of o and typeof o[k] is 'object' then o[k] else {}
					result[k] = merge ov, a[k], b[k]
				else if b?[k] is o?[k]
					result[k] = a[k]

	result

module.exports = merge
