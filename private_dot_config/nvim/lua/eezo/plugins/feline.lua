return {
	'freddiehaddad/feline.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local feline = require('feline')
		feline.setup()
		feline.winbar.setup()
		-- feline.statuscolumn.setup()
	end,
}
