local runtime_path = vim.api.nvim_list_runtime_paths()[1]
local queries_path = runtime_path .. "/after/queries"

local function write(lang, file, content)
	local lang_path = queries_path .. "/" .. lang
	if vim.fn.isdirectory(lang_path) == 0 then
		vim.fn.mkdir(lang_path)
	end

	local file_handle = io.open(lang_path .. "/" .. file .. ".scm", "w")
	io.output(file_handle)
	io.write(content)
	io.close(file_handle)
end

local function python()
	local injections = [[
; extends
;; STRING SQL INJECTION
((string_content) @sql (#match? @sql "^\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n"))
;; STRING SURREALDB INJECTION
((string_content) @surrealdb (#match? @surrealdb "^\n*( )*-{2,}( )*[sS][uU][rR][qQ][lL]( )*\n"))
]]
	write("python", "injections", injections)
end
local function javascript() end

local function typescript()
	local injections = [[
; extends
;; STRING SQL INJECTION
((template_string) @sql (#match? @sql "^`\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n"))

(((comment) @_comment (#match? @_comment "sql") (lexical_declaration(variable_declarator[(string(string_fragment)@sql)(template_string)@sql]))) @sql)

;; STRING SURREALDB INJECTION
((template_string) @surrealdb (#match? @surrealdb "^`\n*( )*-{2,}( )*[sS][uU][rR][qQ][lL]( )*\n"))

(((comment) @_comment (#match? @_comment "surql") (lexical_declaration(variable_declarator[(string(string_fragment)@surrealdb)(template_string)@surrealdb]))) @surrealdb)
	]]
	write("typescript", "injections", injections)
end

local function surrealdb() end

local function init()
	if vim.fn.isdirectory(queries_path) == 0 then
		vim.fn.mkdir(queries_path)
	end
	python()
	typescript()
end

local function setup()
	init()
end

return { setup = setup }
