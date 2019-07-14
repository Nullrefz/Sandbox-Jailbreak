menuTypes = {}

if CLIENT then
    JB.activeMenu = nil

    function JB:RegisterMenu(slots, menuName)
        local menu = {}
        menu.active = false

        menu.Show = function()
            if not self.active then
                self.active = true
                self.panel = vgui.Create("JailbreakOptionMenu")
                self.panel:SetSize(w, h)
                self.panel:SetPos(0, 0)

                for k, v in ipairs(slots) do
                    self.panel:AddSlot(v.NAME, v.ACTION, v.COLOR, v.CLOSE)
                end

                menu.Hide = function()
                    self.active = false

                    if self.panel:IsValid() then
                        self.panel:Exit()
                    end
                end
            end
        end

        menuTypes["menuName"] = menu

        return menu
    end
end