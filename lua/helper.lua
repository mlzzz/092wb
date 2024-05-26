--- 来源：https://github.com/yanhuacuo/98wubi-tables
--- helper.lua
---  List features and usage of the schema.

local function translator(input, seg)
  if input:find('^aid$') then
    local table = {
          { '拆分显隐', 'Ctrl + Shift + H' }
        , { '拼音显隐', 'Ctrl + Shift + J' }
        , { '字集切换', 'Ctrl + Shift + U' }
        , { '繁简切换', 'Ctrl + Shift + F' }
        , { 'Emoji表情', 'Ctrl + Shift + M' }
        , { '临时拼音', 'z键引导临时拼音' }
        , { '重复历史', 'z键兼有重复历史' }
        , { '方案选单', 'Ctrl+Shift+`' }
        , { '大写数字', 'R(大写) + 数字' }
        , { '公历转农历', 'N(大写) + 20240422' }
        , { '农历', 'nl' }
        , { '时间', 'time' }
        , { '日期', 'date' }
        , { '星期', 'week' }
        , { '全角', 'Shift + Space' }
        , { '撤销上屏', 'Alt+Backspace' }
        , { '英文标点', 'Ctrl+ + .' }
        , { '帮助', 'aid' }
        , { '注释', 'Ctrl + Shift + Return' }
    }
    for k, v in ipairs(table) do
      local cand = Candidate('aid', seg.start, seg._end, v[2], ' ' .. v[1])
      cand.preedit = input .. '\t说明'
      yield(cand)
    end
  end
end

return translator
