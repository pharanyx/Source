module("affs", package.seeall)


-- Jagged Affliction Handling


function has(aff)
	return affs[aff] and true or false
end


