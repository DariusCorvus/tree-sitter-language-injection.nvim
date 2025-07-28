local M = {}
local default_config = {
	path = vim.fn.stdpath("config") .. "/queries",
	queries = {},
}
local config = {}

local templates = {
	rust = {
		string = {
			langs = {
				{ name = "sql", match = "^(\r\n|\r|\n)*-{2,}( )*{lang}" },
				{ name = "javascript", match = "^(\r\n|\r|\n)*/{2,}( )*{lang}" },
				{ name = "typescript", match = "^(\r\n|\r|\n)//+( )*{lang}" },
				{ name = "html", match = "^(\r\n|\r|\n)\\<\\!-{2,}( )*{lang}( )*-{2,}\\>" },
				{ name = "css", match = "^(\r\n|\r|\n)/\\*+( )*{lang}( )*\\*+/" },
				{ name = "python", match = "^(\r\n|\r|\n)*#+( )*{lang}" },
			},
			query = [[
; query
;; string {name} injection
((string_content) @injection.content
  (#match? @injection.content "{match}")
  (#set! injection.language "{name}"))
        ]],
		},
		comment = {
			langs = {
				{ name = "sql", match = "^//+( )*{lang}( )*" },
				{ name = "javascript", match = "^//+( )*{lang}( )*" },
				{ name = "typescript", match = "^//+( )*{lang}( )*" },
				{ name = "html", match = "^//+( )*{lang}( )*" },
				{ name = "css", match = "^//+( )*{lang}( )*" },
				{ name = "python", match = "^//+( )*{lang}( )*" },
			},
			query = [[
; query
;; comment {name} injection
((line_comment) 
 @comment .
 (let_declaration 
   value: 
   (raw_string_literal
     (string_content) 
     @injection.content)
    )
  (#match? @comment "{match}")
  (#set! injection.language "{name}")
  )
        ]],
		},
	},
	python = {
		string = {
			langs = {
				{ name = "sql", match = "^(\r\n|\r|\n)*-{2,}( )*{lang}" },
				{ name = "javascript", match = "^(\r\n|\r|\n)*/{2,}( )*{lang}" },
				{ name = "typescript", match = "^(\r\n|\r|\n)//+( )*{lang}" },
				{ name = "html", match = "^(\r\n|\r|\n)\\<\\!-{2,}( )*{lang}( )*-{2,}\\>" },
				{ name = "css", match = "^(\r\n|\r|\n)/\\*+( )*{lang}( )*\\*+/" },
				{ name = "python", match = "^(\r\n|\r|\n)*#+( )*{lang}" },
			},
			query = [[
; query
;; string {name} injection
((string_content) @injection.content 
                   (#match? @injection.content "{match}")
                   (#set! injection.language "{name}"))
]],
		},
		comment = {
			langs = {
				{ name = "sql", match = "^#+( )*{lang}( )*" },
				{ name = "javascript", match = "^#+( )*{lang}( )*" },
				{ name = "typescript", match = "^#+( )*{lang}( )*" },
				{ name = "html", match = "^#+( )*{lang}( )*" },
				{ name = "css", match = "^#+( )*{lang}( )*" },
				{ name = "python", match = "^#+( )*{lang}( )*" },
			},
			query = [[
; query
;; comment {name} injection
((comment) @comment .
           (expression_statement
             (assignment right: 
                         (string
                           (string_content)
                           @injection.content 
                           (#match? @comment "{match}") 
                           (#set! injection.language "{name}")))))
]],
		},
	},
	typescript = {
		string = {
			langs = {
				{ name = "sql", match = "^(\r\n|\r|\n)*-{2,}( )*{lang}" },
				{ name = "javascript", match = "^(\r\n|\r|\n)*/{2,}( )*{lang}" },
				{ name = "typescript", match = "^(\r\n|\r|\n)//+( )*{lang}" },
				{ name = "html", match = "^(\r\n|\r|\n)\\<\\!-{2,}( )*{lang}( )*-{2,}\\>" },
				{ name = "css", match = "^(\r\n|\r|\n)/\\*+( )*{lang}( )*\\*+/" },
				{ name = "python", match = "^(\r\n|\r|\n)*#+( )*{lang}" },
			},
			query = [[
; query
;; string {name} injection
((string_fragment) @injection.content
                   (#match? @injection.content "{match}")
                   (#set! injection.language "{name}"))
        ]],
		},
		comment = {
			langs = {
				{ name = "sql", match = "^//+( )*{lang}( )*" },
				{ name = "javascript", match = "^//+( )*{lang}( )*" },
				{ name = "typescript", match = "^//+( )*{lang}( )*" },
				{ name = "html", match = "^//+( )*{lang}( )*" },
				{ name = "css", match = "^//+( )*{lang}( )*" },
				{ name = "python", match = "^//+( )*{lang}( )*" },
			},
			query = [[
; query
;; comment {name} injection
((comment)
 @comment .
 (lexical_declaration
   (variable_declarator 
     value: [
             (string(string_fragment)@injection.content) 
             (template_string(string_fragment)@injection.content)
             ]@injection.content)  
   )
  (#match? @comment "{match}")
  (#set! injection.language "{name}")
 )
        ]],
		},
	},
	javascript = {
		string = {
			langs = {
				{ name = "sql", match = "^(\r\n|\r|\n)*-{2,}( )*{lang}" },
				{ name = "javascript", match = "^(\r\n|\r|\n)*/{2,}( )*{lang}" },
				{ name = "typescript", match = "^(\r\n|\r|\n)//+( )*{lang}" },
				{ name = "html", match = "^(\r\n|\r|\n)\\<\\!-{2,}( )*{lang}( )*-{2,}\\>" },
				{ name = "css", match = "^(\r\n|\r|\n)/\\*+( )*{lang}( )*\\*+/" },
				{ name = "python", match = "^(\r\n|\r|\n)*#+( )*{lang}" },
			},
			query = [[
; query
;; string {name} injection
((string_fragment) @injection.content
                   (#match? @injection.content "{match}")
                   (#set! injection.language "{name}"))
        ]],
		},
		comment = {
			langs = {
				{ name = "sql", match = "^//+( )*{lang}( )*" },
				{ name = "javascript", match = "^//+( )*{lang}( )*" },
				{ name = "typescript", match = "^//+( )*{lang}( )*" },
				{ name = "html", match = "^//+( )*{lang}( )*" },
				{ name = "css", match = "^//+( )*{lang}( )*" },
				{ name = "python", match = "^//+( )*{lang}( )*" },
			},
			query = [[
; query
;; comment {name} injection
((comment)
 @comment .
 (lexical_declaration
   (variable_declarator
     value: [
             (string(string_fragment)@injection.content)
             (template_string(string_fragment)@injection.content)
             ]@injection.content)
   )
  (#match? @comment "{match}")
  (#set! injection.language "{name}")
 )
        ]],
		},
	},
}

-- Function to merge two tables recursively
local function deepMerge(target, source)
	for key, value in pairs(source) do
		if type(value) == "table" and type(target[key]) == "table" then
			if key == "langs" then
				-- Concatenate the langs arrays and ensure uniqueness
				local existingEntries = {}
				-- Add existing entries to the map for uniqueness
				for _, entry in ipairs(target[key]) do
					existingEntries[entry.name] = entry
				end

				-- Add new entries from the source to the map
				for _, entry in ipairs(value) do
					existingEntries[entry.name] = entry -- This will overwrite the entry if it exists
				end

				-- Convert the mapping back to an array (ensuring uniqueness)
				target[key] = {}
				for _, entry in pairs(existingEntries) do
					table.insert(target[key], entry)
				end
			else
				-- If the key is not "langs", just perform a regular merge
				deepMerge(target[key], value)
			end
		else
			-- Otherwise, directly assign the value from the source to the target
			target[key] = value
		end
	end
end

local function createCaseInsensitivePattern(str)
	local pattern = str:gsub(".", function(c)
		return "[" .. c:lower() .. c:upper() .. "]"
	end)
	return pattern
end

local function write(lang, file, content)
	local queries_path = config.path
	local lang_path = queries_path .. "/" .. lang
	if vim.fn.isdirectory(lang_path) == 0 then
		vim.fn.mkdir(lang_path)
	end

	local file_handle = io.open(lang_path .. "/" .. file .. ".scm", "w")
	if file_handle then
		io.output(file_handle)
		io.write(content)
		io.close(file_handle)
	end
end

local function init()
	local queries_path = config.path
	local queries = config.queries or {}
	deepMerge(templates, queries)
	if vim.fn.isdirectory(queries_path) == 0 then
		vim.fn.mkdir(queries_path)
	end
	if vim.fn.isdirectory(queries_path) == 0 then
		vim.fn.mkdir(queries_path)
	end
	for lang, langData in pairs(templates) do
		local result = ";extends\n"
		for _, typeData in pairs(langData) do
			-- Replace placeholders in the query string
			if typeData.langs and typeData.query then -- Check if langs and query exist
				for _, entry in ipairs(typeData.langs) do
					-- Replace placeholders in the query string
					local query = typeData.query
					local transformed_match =
						entry.match:gsub("\\", "\\\\"):gsub("\r\n", "\\r\\n"):gsub("\r", "\\r"):gsub("\n", "\\n")
					query = query:gsub("{match}", transformed_match) -- Replace {match} (double escaping)
					query = query:gsub("{lang}", createCaseInsensitivePattern(entry.name))
					query = query:gsub("{name}", entry.name)

					-- Concatenate the modified query string
					result = result .. "\n" .. query
				end
			end
		end

		write(lang, "injections", result)
	end
end

function M.setup(user_config)
	user_config = user_config or {}
	config = vim.tbl_deep_extend("force", default_config, user_config)

	init()
end

return M
