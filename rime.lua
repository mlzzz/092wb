-- 以词定字，默认为左右中括号 [ ]
-- 来源：https://github.com/BlindingDark/rime-lua-select-character
select_character_processor = require("select_character")

core = require("core_filter")

-- 日期时间，可在方案中配置触发关键字。
date_translator = require("date_translator")

-- 农历，可在方案中配置触发关键字。
lunar = require("lunar")

-- 数字、人民币大写，R 开头
number_translator = require("number_translator")

-- 暴力 GC
-- 详情 https://github.com/hchunhui/librime-lua/issues/307
-- 这样也不会导致卡顿，那就每次都调用一下吧，内存稳稳的
function force_gc()
	-- collectgarbage()
	collectgarbage("step")
end

-- 临时用的
function debug_checker(input, env)
	for cand in input:iter() do
		yield(
			ShadowCandidate(
				cand,
				cand.type,
				cand.text,
				env.engine.context.input .. " - " .. env.engine.context:get_preedit().text .. " - " .. cand.preedit
			)
		)
	end
end
