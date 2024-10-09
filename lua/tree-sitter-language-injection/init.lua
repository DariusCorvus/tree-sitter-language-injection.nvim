local runtime_path = vim.api.nvim_list_runtime_paths()[1]
local after_path = runtime_path .. "/after"
local queries_path = runtime_path .. "/after/queries"

local queries = {
	python = {
		injections = [[
;; query
; extends
;; STRING SQL INJECTION
(
 (string_content) @injection.content 
 (#match? @injection.content "^\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n") 
 (#set! injection.language "sql"))

;; COMMENT SQL INJECTION
((comment) @comment .
           (expression_statement
             (assignment right: 
              (string
                (string_content)
                @injection.content
                (#match? @comment "( )*[sS][qQ][lL]( )*") 
                (#set! injection.language "sql")))))
		]],
	},
	typescript = {
		injections = [[
;; query
; extends
;; STRING SQL INJECTION
((string_fragment) @injection.content 
                   (#match? @injection.content "^(\r\n|\r|\n)*-{2,}( )*[sS][qQ][lL]")
                   (#set! injection.language "sql"))

;; COMMENT SQL INJECTION
((comment)
 @comment .
 (lexical_declaration
   (variable_declarator 
     value: [
             (string(string_fragment)@injection.content) 
             (template_string(string_fragment)@injection.content)
             ]@injection.content)  
   )
  (#match? @comment "^//( )*[sS][qQ][lL]")
  (#set! injection.language "sql")
 )
		]],
	},
	javascript = {
		injections = [[
;; query
; extends
;; STRING SQL INJECTION
((string_fragment) @injection.content 
                   (#match? @injection.content "^(\r\n|\r|\n)*-{2,}( )*[sS][qQ][lL]")
                   (#set! injection.language "sql"))

;; COMMENT SQL INJECTION
((comment)
 @comment .
 (lexical_declaration
   (variable_declarator 
     value: [
             (string(string_fragment)@injection.content) 
             (template_string(string_fragment)@injection.content)
             ]@injection.content)  
   )
  (#match? @comment "^//( )*[sS][qQ][lL]")
  (#set! injection.language "sql")
 )
		]],
	},
}

local function createLanguageInjection(query, lang)
  local pattern = createCaseInsensitivePattern(lang)
  query = query:gsub("{lang}", lang)
  query = query:gsub("{pattern}", pattern)
  return query
end

local function createCaseInsensitivePattern(str)
    local pattern = str:gsub(".", function(c)
        return "[" .. c:lower() .. c:upper() .. "]"
    end)
    return pattern
end

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

local function init()
	if vim.fn.isdirectory(after_path) == 0 then
		vim.fn.mkdir(after_path)
	end
	if vim.fn.isdirectory(queries_path) == 0 then
		vim.fn.mkdir(queries_path)
	end
	for lang, value in pairs(queries) do
		for file, content in pairs(value) do
			write(lang, file, content)
		end
	end
  write("test", "injections", createLanguageInjection([[
;query
;extends
((string_fragment) @injection.content 
                   (#match? @injection.content "^(\r\n|\r|\n)*-{2,}( )*[sS][qQ][lL]")
                   (#set! injection.language "sql"))
  ]], "sql"))
end

local function setup()
	init()
end

return { setup = setup }
