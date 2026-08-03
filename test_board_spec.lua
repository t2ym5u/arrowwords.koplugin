local DIR = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"

package.preload["gettext"] = function()
    return setmetatable({}, { __call = function(_, s) return s end })
end
package.path = DIR .. "common/?.lua;" .. DIR .. "?.lua;" .. package.path

describe("ArrowwordsBoard", function()
    local Board

    setup(function()
        Board = require("board")
    end)

    describe("new / _loadPuzzle", function()
        it("loads puzzle 1 with an all-empty user grid", function()
            local b = Board:new()
            assert.are.equal(1, b.puzzle_index)
            for r = 1, b.n do
                for c = 1, b.n do
                    assert.are.equal("", b.user[r][c])
                end
            end
        end)

        it("selects the first letter cell", function()
            local b = Board:new()
            assert.is_not_nil(b.sel_r)
            assert.are.equal("l", b.grid[b.sel_r][b.sel_c].t)
        end)

        it("wraps puzzle_index into range via nextPuzzle/prevPuzzle", function()
            local b = Board:new()
            b:prevPuzzle()
            assert.are.equal(Board.NUM_PUZZLES, b.puzzle_index)
            b:nextPuzzle()
            assert.are.equal(1, b.puzzle_index)
        end)
    end)

    describe("selectCell", function()
        it("ignores clue cells and out-of-range coordinates", function()
            local b = Board:new()
            local before_r, before_c = b.sel_r, b.sel_c
            b:selectCell(0, 0)
            assert.are.equal(before_r, b.sel_r)
            assert.are.equal(before_c, b.sel_c)
        end)
    end)

    describe("typeLetter / checkLetters / _checkWin", function()
        it("filling every letter cell with the solution wins the puzzle", function()
            local b = Board:new()
            for r = 1, b.n do
                for c = 1, b.n do
                    if b.grid[r][c].t == "l" then
                        b.sel_r, b.sel_c = r, c
                        b:typeLetter(b.solution[r][c])
                    end
                end
            end
            assert.is_true(b.won)
            local wrong = b:checkLetters()
            for r = 1, b.n do
                for c = 1, b.n do
                    assert.is_false(wrong[r][c])
                end
            end
        end)

        it("a wrong letter is reported by checkLetters and blocks the win", function()
            local b = Board:new()
            -- Find a letter cell and type a deliberately wrong letter.
            local r, c
            for rr = 1, b.n do
                for cc = 1, b.n do
                    if b.grid[rr][cc].t == "l" then r, c = rr, cc; break end
                end
                if r then break end
            end
            local wrong_letter = (b.solution[r][c] == "Z") and "A" or "Z"
            b.sel_r, b.sel_c = r, c
            b:typeLetter(wrong_letter)
            assert.is_false(b.won)
            assert.is_true(b:checkLetters()[r][c])
        end)
    end)

    describe("reveal / clearAll", function()
        it("reveal fills every letter cell with the solution and wins", function()
            local b = Board:new()
            b:reveal()
            assert.is_true(b.won)
            local filled, total = b:countFilled()
            assert.are.equal(total, filled)
        end)

        it("clearAll empties the grid and resets won", function()
            local b = Board:new()
            b:reveal()
            b:clearAll()
            assert.is_false(b.won)
            local filled = b:countFilled()
            assert.are.equal(0, filled)
        end)
    end)

    describe("serialize / load", function()
        it("round-trips user grid and selection", function()
            local b = Board:new()
            b.sel_r, b.sel_c = b.sel_r, b.sel_c
            b:typeLetter(b.solution[b.sel_r][b.sel_c])
            local data = b:serialize()

            local b2 = Board:new()
            assert.is_true(b2:load(data))
            assert.are.equal(b.puzzle_index, b2.puzzle_index)
            local any_match = false
            for r = 1, b.n do
                for c = 1, b.n do
                    if b.user[r][c] ~= "" then
                        assert.are.equal(b.user[r][c], b2.user[r][c])
                        any_match = true
                    end
                end
            end
            assert.is_true(any_match)
        end)

        it("load returns false for invalid data", function()
            local b = Board:new()
            assert.is_false(b:load(nil))
            assert.is_false(b:load({}))
        end)
    end)
end)
