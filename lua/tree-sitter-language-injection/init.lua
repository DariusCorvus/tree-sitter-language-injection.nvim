local runtime_path = vim.api.nvim_list_runtime_paths()[1]
local after_path = runtime_path .. "/after"
local queries_path = runtime_path .. "/after/queries"

local templates = {
    python = {
        string = {
            langs = {
                { name = "sql", match = "^(\r\n|\r|\n)*-{2,}( )*{lang}" },
                { name = "javascript", match = "^(\r\n|\r|\n)*/{2,}( )*{lang}" },
                { name = "html", match = "^(\r\n|\r|\n)\\<\\!-{2,}( )*{lang}( )*-{2,}\\>" }
            },
            query = [[
; query
;; string {name} injection
((string_content) @injection.content 
                   (#match? @injection.content "{match}")
                   (#set! injection.language "{name}"))
]]
        },
        comment = {
            langs = {
              { name = "sql", match = "( )*{lang}( )*"},
      -- { name = "javascript", match = "( )*{lang}( )*"},
      -- { name = "html", match = "( )*{lang}( )*"},
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
]]
        }
    }
}

local function createCaseInsensitivePattern(str)
    local pattern = str:gsub(".", function(c)
        return "[" .. c:lower() .. c:upper() .. "]"
    end)
    return pattern
end

local function createLanguageInjection(query, lang)
  local pattern = createCaseInsensitivePattern(lang)
  query = query:gsub("{lang}", lang)
  query = query:gsub("{pattern}", pattern)
  return query
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
  for lang, langData in pairs(templates) do
    local result = ";extends\n"
    for type, typeData in pairs(langData) do
            -- Replace placeholders in the query string
        if typeData.langs and typeData.query then  -- Check if langs and query exist
            for _, entry in ipairs(typeData.langs) do
                -- Replace placeholders in the query string
                local query = typeData.query
                query = query:gsub("{match}", entry.match:gsub("\\", "\\\\"):gsub("\r\n", "\\r\\n"):gsub("\r", "\\r"):gsub("\n", "\\n"))  -- Replace {match} (double escaping)
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

local function setup()
	init()
end

return { setup = setup }
