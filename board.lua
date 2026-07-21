-- Arrowwords (Mots fléchés) — board logic
--
-- Grid cell types:
--   t="c"  clue cell  — tx=text, a="r"|"d"|"b" (right / down / both)
--   t="l"  letter cell — player fills in a letter
--
-- Arrows:
--   "r"  → answer runs right starting from the next cell in the same row
--   "d"  → answer runs down starting from the next cell in the same column
--   "b"  → both right and down (two answers start from this clue cell)
--
-- Every contiguous run of letter cells in a row must be immediately preceded
-- by a clue cell with a="r" or a="b".
-- Every contiguous run of letter cells in a column must be immediately
-- preceded (above) by a clue cell with a="d" or a="b".

-- Shorthand constructors used in PUZZLES table
local function c(tx, a) return { t = "c", tx = tx, a = a } end
local function l()       return { t = "l" } end

-- ---------------------------------------------------------------------------
-- PUZZLES
-- Each puzzle: title, n (grid size), grid[r][c], solution[r][c].
-- solution[r][c] = uppercase letter for letter cells, "" for clue cells.
-- ---------------------------------------------------------------------------

local PUZZLES = {
    {
        title = "Découverte",
        n = 7,
        grid = {
            { c("Base de la pâte à pain\nMeuble pour s'asseoir", "b"), l(), l(), l(), l(), l(), l() },
            { l(), c("Bassin d'eau calme corallien", "d"), c("Roule sur des rails", "d"), c("Rapace majestueux", "d"), c("Galette fine, sucrée ou salée", "d"), c("On y loge en voyage", "d"), c("Éclaire la pièce", "d") },
            { l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l() },
        },
        solution = {
            { "", "F", "A", "R", "I", "N", "E" },
            { "C", "", "", "", "", "", "" },
            { "H", "L", "T", "A", "C", "H", "L" },
            { "A", "A", "R", "I", "R", "O", "A" },
            { "I", "G", "A", "G", "E", "T", "M" },
            { "S", "O", "I", "L", "P", "E", "P" },
            { "E", "N", "N", "E", "E", "L", "E" },
        },
    },
    {
        title = "Balade",
        n = 9,
        grid = {
            { c("Espace vert public\nSe termine par la main", "b"), l(), l(), l(), l(), c("Terre entourée d'eau\nPalmipède de la basse-cour", "b"), l(), l(), l() },
            { l(), c("Pièce pour cuisiner", "d"), c("Voie de la ville", "d"), c("Petit gâteau sec", "d"), c("Cours d'eau qui rejoint un fleuve", "d"), l(), c("Mâle de la vache", "d"), c("Légume orange du potager", "d"), c("La Terre en est une", "d") },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), c("Couvre la maison", "d"), l(), l(), l() },
            { c("Relie la tête au tronc", "d"), l(), c("Fruit acide et jaune\nCéréale asiatique", "b"), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
        },
        solution = {
            { "", "P", "A", "R", "C", "", "I", "L", "E" },
            { "B", "", "", "", "", "O", "", "", "" },
            { "R", "C", "R", "B", "R", "I", "T", "C", "P" },
            { "A", "U", "U", "I", "I", "E", "A", "A", "L" },
            { "S", "I", "E", "S", "V", "", "U", "R", "A" },
            { "", "S", "", "C", "I", "T", "R", "O", "N" },
            { "C", "I", "R", "U", "E", "O", "E", "T", "E" },
            { "O", "N", "I", "I", "R", "I", "A", "T", "T" },
            { "U", "E", "Z", "T", "E", "T", "U", "E", "E" },
        },
    },
    {
        title = "Panorama",
        n = 9,
        grid = {
            { c("Comporte cinq doigts\nEnjambe une rivière", "b"), l(), l(), l(), l(), c("On le respire", "r"), l(), l(), l() },
            { l(), c("À une ou deux bosses", "r"), l(), l(), l(), l(), l(), l(), l() },
            { l(), c("Sépare deux pièces", "r"), l(), l(), l(), c("Ouvre une porte\nAvancée extérieure d'un étage", "b"), l(), l(), l() },
            { l(), c("Grand oiseau noir croasseur", "r"), l(), l(), l(), l(), l(), l(), l() },
            { l(), c("Côte rocheuse abrupte", "r"), l(), l(), l(), l(), l(), l(), l() },
            { c("Sert à respirer et sentir\nBaudet", "b"), l(), l(), l(), c("Cousin sauvage du chien", "r"), l(), l(), l(), l() },
            { l(), c("Masse de glace en montagne", "r"), l(), l(), l(), l(), l(), l(), l() },
            { l(), c("Niche sur les cheminées", "r"), l(), l(), l(), l(), l(), l(), l() },
            { l(), c("Pièce sous le toit", "r"), l(), l(), l(), l(), l(), l(), l() },
        },
        solution = {
            { "", "M", "A", "I", "N", "", "A", "I", "R" },
            { "P", "", "C", "H", "A", "M", "E", "A", "U" },
            { "O", "", "M", "U", "R", "", "C", "L", "E" },
            { "N", "", "C", "O", "R", "B", "E", "A", "U" },
            { "T", "", "F", "A", "L", "A", "I", "S", "E" },
            { "", "N", "E", "Z", "", "L", "O", "U", "P" },
            { "A", "", "G", "L", "A", "C", "I", "E", "R" },
            { "N", "", "C", "I", "G", "O", "G", "N", "E" },
            { "E", "", "G", "R", "E", "N", "I", "E", "R" },
        },
    },
    {
        title = "Campagne",
        n = 9,
        grid = {
            { c("Ronronne sur le canapé\nEnveloppe le corps", "b"), l(), l(), l(), l(), c("Chante au lever du jour\nPointe de terre dans la mer", "b"), l(), l(), l() },
            { l(), c("Brûle et réchauffe", "d"), c("Chute d'eau", "d"), c("Range les vêtements", "d"), c("Relie les pièces", "d"), l(), c("Légume vert en gousse", "d"), c("Petit oiseau des villes", "d"), c("Laisse entrer la lumière", "d") },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), c("Boisson blanche de la vache", "d"), l(), l(), l() },
            { c("Céréale à pain", "d"), c("Petite montagne arrondie\nSaison chaude", "b"), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
        },
        solution = {
            { "", "C", "H", "A", "T", "", "C", "O", "Q" },
            { "P", "", "", "", "", "C", "", "", "" },
            { "E", "F", "C", "A", "C", "A", "H", "M", "F" },
            { "A", "E", "A", "R", "O", "P", "A", "O", "E" },
            { "U", "U", "S", "M", "U", "", "R", "I", "N" },
            { "", "", "C", "O", "L", "L", "I", "N", "E" },
            { "B", "E", "A", "I", "O", "A", "C", "E", "T" },
            { "L", "T", "D", "R", "I", "I", "O", "A", "R" },
            { "E", "E", "E", "E", "R", "T", "T", "U", "E" },
        },
    },
    {
        title = "Escapade",
        n = 7,
        grid = {
            { c("Se mange en dessert, avec des bougies\nCharcuterie de porc", "b"), l(), l(), l(), l(), l(), l() },
            { l(), c("Guide les bateaux la nuit", "r"), l(), l(), l(), l(), l() },
            { l(), c("Voie pour les voitures", "r"), l(), l(), l(), l(), l() },
            { l(), c("Grand espace ouvert en ville", "r"), l(), l(), l(), l(), l() },
            { l(), c("Expose des œuvres d'art", "r"), l(), l(), l(), l(), l() },
            { l(), c("Herbe aromatique grise", "r"), l(), l(), l(), l(), l() },
            { l(), c("Adoucit le café", "r"), l(), l(), l(), l(), l() },
        },
        solution = {
            { "", "G", "A", "T", "E", "A", "U" },
            { "J", "", "P", "H", "A", "R", "E" },
            { "A", "", "R", "O", "U", "T", "E" },
            { "M", "", "P", "L", "A", "C", "E" },
            { "B", "", "M", "U", "S", "E", "E" },
            { "O", "", "S", "A", "U", "G", "E" },
            { "N", "", "S", "U", "C", "R", "E" },
        },
    },
    {
        title = "Ménagerie",
        n = 9,
        grid = {
            { c("Face arrière du corps\nOrgane qui filtre le sang", "b"), l(), l(), l(), c("Boisson noire du matin\nOn y dort", "b"), l(), l(), l(), l() },
            { l(), c("H2O", "d"), c("Petit rongeur de compagnie", "d"), c("Court vite dans la savane", "d"), l(), c("Boisson issue du raisin", "d"), c("Cousin rugueux de la grenouille", "d"), c("Butine et fait le miel", "d"), c("Petit mustélidé agile", "d") },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), c("Félin aux oreilles pointues", "d"), l(), l(), l(), l() },
            { c("Boisson chaude infusée", "d"), c("Assaisonne les plats\nRongeur des égouts", "b"), l(), l(), l(), c("Oiseau bavard noir et blanc\nPour transporter ses affaires", "b"), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
            { l(), l(), l(), l(), l(), l(), l(), l(), l() },
        },
        solution = {
            { "", "D", "O", "S", "", "C", "A", "F", "E" },
            { "F", "", "", "", "L", "", "", "", "" },
            { "O", "E", "H", "G", "I", "V", "C", "A", "B" },
            { "I", "A", "A", "A", "T", "I", "R", "B", "E" },
            { "E", "U", "M", "Z", "", "N", "A", "E", "L" },
            { "", "", "S", "E", "L", "", "P", "I", "E" },
            { "T", "R", "T", "L", "Y", "S", "A", "L", "T" },
            { "H", "A", "E", "L", "N", "A", "U", "L", "T" },
            { "E", "T", "R", "E", "X", "C", "D", "E", "E" },
        },
    },
}

-- ---------------------------------------------------------------------------
-- ArrowwordsBoard
-- ---------------------------------------------------------------------------

local ArrowwordsBoard = {}
ArrowwordsBoard.__index = ArrowwordsBoard

function ArrowwordsBoard:new(opts)
    opts = opts or {}
    local obj = setmetatable({
        puzzle_index = opts.puzzle_index or 1,
        n            = 7,
        grid         = nil,   -- puzzle cell definitions {t, tx, a}
        solution     = nil,   -- solution letters (string or "")
        user         = nil,   -- user-entered letters
        sel_r        = nil,
        sel_c        = nil,
        won          = false,
    }, self)
    obj:_loadPuzzle(obj.puzzle_index)
    return obj
end

function ArrowwordsBoard:_loadPuzzle(idx)
    idx = ((idx - 1) % #PUZZLES) + 1
    self.puzzle_index = idx
    local p = PUZZLES[idx]
    self.n   = p.n or 7
    self.grid = p.grid
    self.solution = p.solution
    self.title = p.title or ""

    -- Init user grid
    local n = self.n
    self.user = {}
    for r = 1, n do
        self.user[r] = {}
        for c = 1, n do
            self.user[r][c] = ""
        end
    end

    self.sel_r = nil
    self.sel_c = nil
    self.won   = false

    -- Move selection to first letter cell
    for r = 1, n do
        for cc = 1, n do
            if self.grid[r][cc].t == "l" then
                self.sel_r = r
                self.sel_c = cc
                return
            end
        end
    end
end

function ArrowwordsBoard:getCell(r, c)
    return self.grid[r][c]
end

function ArrowwordsBoard:selectCell(r, c)
    if r < 1 or r > self.n or c < 1 or c > self.n then return end
    if self.grid[r][c].t ~= "l" then return end
    self.sel_r = r
    self.sel_c = c
end

-- Find the word containing (sel_r, sel_c) in a given direction ("r"=right, "d"=down)
-- Returns: direction arrow, start_r, start_c, end_r, end_c or nil
function ArrowwordsBoard:_findWord(r, c)
    local n = self.n
    -- Check if covered horizontally: walk left to find a clue with arrow r or b
    local cr = c - 1
    while cr >= 1 and self.grid[r][cr].t == "l" do
        cr = cr - 1
    end
    local h_dir = nil
    if cr >= 1 and self.grid[r][cr].t == "c" then
        local a = self.grid[r][cr].a
        if a == "r" or a == "b" then
            h_dir = { clue_r = r, clue_c = cr }
        end
    end

    -- Check if covered vertically: walk up to find a clue with arrow d or b
    local ur = r - 1
    while ur >= 1 and self.grid[ur][c].t == "l" do
        ur = ur - 1
    end
    local v_dir = nil
    if ur >= 1 and self.grid[ur][c].t == "c" then
        local a = self.grid[ur][c].a
        if a == "d" or a == "b" then
            v_dir = { clue_r = ur, clue_c = c }
        end
    end

    return h_dir, v_dir
end

-- Advance selection in the direction the current cell belongs to.
-- Prefer horizontal if available, else vertical.
function ArrowwordsBoard:_advanceSelection()
    if not self.sel_r then return end
    local r, c = self.sel_r, self.sel_c
    local n = self.n
    local h_dir, v_dir = self:_findWord(r, c)
    if h_dir then
        -- Advance right in the same row
        local nc = c + 1
        while nc <= n do
            if self.grid[r][nc].t == "l" then
                self.sel_c = nc; return
            elseif self.grid[r][nc].t == "c" then
                break
            end
            nc = nc + 1
        end
    elseif v_dir then
        -- Advance down in the same column
        local nr = r + 1
        while nr <= n do
            if self.grid[nr][c].t == "l" then
                self.sel_r = nr; return
            elseif self.grid[nr][c].t == "c" then
                break
            end
            nr = nr + 1
        end
    end
end

function ArrowwordsBoard:typeLetter(letter)
    if self.won then return end
    if not self.sel_r then return end
    local r, c = self.sel_r, self.sel_c
    if self.grid[r][c].t ~= "l" then return end
    self.user[r][c] = letter:upper()
    self:_advanceSelection()
    self:_checkWin()
end

function ArrowwordsBoard:deleteLetter()
    if not self.sel_r then return end
    local r, c = self.sel_r, self.sel_c
    if self.user[r][c] ~= "" then
        self.user[r][c] = ""
    else
        -- Retreat
        local n = self.n
        local h_dir, v_dir = self:_findWord(r, c)
        if h_dir then
            local nc = c - 1
            while nc >= 1 do
                if self.grid[r][nc].t == "l" then
                    self.sel_c = nc
                    self.user[r][nc] = ""
                    return
                elseif self.grid[r][nc].t == "c" then
                    break
                end
                nc = nc - 1
            end
        elseif v_dir then
            local nr = r - 1
            while nr >= 1 do
                if self.grid[nr][c].t == "l" then
                    self.sel_r = nr
                    self.user[nr][c] = ""
                    return
                elseif self.grid[nr][c].t == "c" then
                    break
                end
                nr = nr - 1
            end
        end
    end
    self.won = false
end

function ArrowwordsBoard:clearAll()
    for r = 1, self.n do
        for cc = 1, self.n do
            self.user[r][cc] = ""
        end
    end
    self.won = false
end

function ArrowwordsBoard:reveal()
    for r = 1, self.n do
        for cc = 1, self.n do
            if self.grid[r][cc].t == "l" then
                self.user[r][cc] = self.solution[r][cc] or ""
            end
        end
    end
    self.won = true
end

-- Returns grid of booleans: true = wrong fill (not matching solution)
function ArrowwordsBoard:checkLetters()
    local wrong = {}
    for r = 1, self.n do
        wrong[r] = {}
        for cc = 1, self.n do
            local usr = self.user[r][cc]
            wrong[r][cc] = (self.grid[r][cc].t == "l" and usr ~= "" and usr ~= self.solution[r][cc])
        end
    end
    return wrong
end

function ArrowwordsBoard:_checkWin()
    for r = 1, self.n do
        for cc = 1, self.n do
            if self.grid[r][cc].t == "l" then
                local sol = self.solution[r][cc]
                if self.user[r][cc] ~= sol then
                    self.won = false; return
                end
            end
        end
    end
    self.won = true
end

function ArrowwordsBoard:countFilled()
    local filled, total = 0, 0
    for r = 1, self.n do
        for cc = 1, self.n do
            if self.grid[r][cc].t == "l" then
                total = total + 1
                if self.user[r][cc] ~= "" then filled = filled + 1 end
            end
        end
    end
    return filled, total
end

function ArrowwordsBoard:nextPuzzle()
    self:_loadPuzzle(self.puzzle_index + 1)
end

function ArrowwordsBoard:prevPuzzle()
    self:_loadPuzzle(self.puzzle_index - 1)
end

-- ---------------------------------------------------------------------------
-- Persistence
-- ---------------------------------------------------------------------------

function ArrowwordsBoard:serialize()
    local flat = {}
    for r = 1, self.n do
        for cc = 1, self.n do
            flat[#flat + 1] = self.user[r][cc]
        end
    end
    return {
        puzzle_index = self.puzzle_index,
        user         = flat,
        sel_r        = self.sel_r,
        sel_c        = self.sel_c,
        won          = self.won,
    }
end

function ArrowwordsBoard:load(data)
    if type(data) ~= "table" or not data.user then return false end
    self:_loadPuzzle(data.puzzle_index or 1)
    local idx = 1
    for r = 1, self.n do
        for cc = 1, self.n do
            self.user[r][cc] = data.user[idx] or ""
            idx = idx + 1
        end
    end
    self.sel_r = data.sel_r or self.sel_r
    self.sel_c = data.sel_c or self.sel_c
    self.won   = data.won or false
    return true
end

ArrowwordsBoard.NUM_PUZZLES = #PUZZLES

return ArrowwordsBoard
