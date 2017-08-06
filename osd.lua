local exports = {}
package.loaded.osd = exports

require "globals"

function exports.displayBanner(line1, line2)
	local bx = 37
	local by = 201
	gui.drawRectangle(bx, by, 181, 19, 0xFF303030, 0xFF000000)
	gui.pixelText(bx + 2, by + 2, line1, 0xFFFFFFFF, 0x00000000)
	gui.pixelText(bx + 2, by + 11, line2, 0xFFFFFFFF, 0x00000000)
end

function exports.displayInputs(controller)
	for b=1,#ButtonNames do
		if (controller[ButtonNames[b]]) then
			gui.pixelText(2, (8 * b) + 26, ButtonNames[b]:sub(4), 0xFFFFFFFF, 0x8080FF80)
		else
			gui.pixelText(2, (8 * b) + 26, ButtonNames[b]:sub(4), 0x80FFFFFF, 0x80808080)
		end
	end
end
	
return exports