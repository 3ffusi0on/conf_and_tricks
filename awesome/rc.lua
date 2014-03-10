-- Standard awesome library--{{{
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Underscore (https://github.com/jtarchie/underscore-lua)
local _ = require("underscore")

-- Eminent dynamic tagging (http://awesome.naquadah.org/wiki/Eminent)
require("eminent")

-- Vicious widgets (http://awesome.naquadah.org/wiki/Vicious)
vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

-- Markup functions
require("markup")
--}}}

-- Laoding ----{{{
function run_once(cmd)
   findme = cmd                                                                                
   firstspace = cmd:find(" ")
   if firstspace then
     findme = cmd:sub(0, firstspace-1)
   end 
   awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")") 
end

run_once("xmodmap .xmodmaprc")
run_once("nm-applet")
-- run_once("xchat")
--}}}

--Theme--{{{
local config_dir = awful.util.getdir("config")
beautiful.init(config_dir .. "/themes/schnouki-zenburn.lua")
--}}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
terminal = "urxvt -fn 'xft:BitStream Vera Sans Mono:pixelsize=16' -geometry +10+35 -bg black -fg white +sb +sr +st +ss"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,            --  1
    awful.layout.suit.tile.bottom,     --  2
    awful.layout.suit.fair,            --  3
    awful.layout.suit.fair.horizontal, --  4
    awful.layout.suit.max,             --  5
    awful.layout.suit.max.fullscreen,  --  6
    awful.layout.suit.magnifier,       --  7
    awful.layout.suit.floating,        --  8
    awful.layout.suit.spiral,          --  9
    awful.layout.suit.spiral.dwindle,  -- 10
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({"➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
mymainmenu = awful.menu({ items = {
	   { "manual", terminal .. " -e man awesome" },
	   { "edit config", editor_cmd .. " " .. awesome.conffile },
	   { "restart", awesome.restart },
	   { "quit", awesome.quit },
	   { "poweroff", terminal .. "-e poweroff" }
       }
   })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- Screens tools--{{{

-- Screen helper
function get_next_screen()
   local s = mouse.screen + 1
   if s > screen.count() then s = 1 end
   return s
end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Switch tag on next screen
function next_screen_viewnext()
   awful.tag.viewnext(get_next_screen())
end
function next_screen_viewprev()
   awful.tag.viewprev(get_next_screen())
end

-- "transient" window
function get_transient(c)
   for k, v in pairs(client.get()) do
      if v.transient_for == c then
         return v
      end
   end
   return c
end
function new_transient(c)
   if client.focus == c.transient_for then
      client.focus = c
   end
end
--}}}

-- {{{ Wibox
separator = wibox.widget.imagebox()
separator:set_image(config_dir .. "/icons/separator.png")

-- Create a textclock widget
mytextclock_icon = wibox.widget.imagebox()
mytextclock_icon:set_image(config_dir .. "/icons/time.png")
mytextclock = awful.widget.textclock("%H:%M")
-- Display on mouse detection. Format : Day n Month Year
mytextclock_t = awful.tooltip({ objects = { mytextclock },
                                timer_function = function()
				    return os.date("%A %e %B %Y") end })

-- Vicious widgets
cpu_mem_gradient = "linear:0,18:0,0:0,#66CC66:0.5,#CCCC66:1,#CC6666"

vicious.cache(vicious.widgets.cpu)
cpu_icon = wibox.widget.imagebox()
cpu_icon:set_image(config_dir .. "/icons/cpu.png")
cpu_widgets = {}
for i = 2, #vicious.widgets.cpu() do
   w = awful.widget.progressbar()
   w:set_width(4)
   w:set_height(18)
   w:set_vertical(true)
   w:set_background_color("#000000")
   w:set_color({type = "linear", from = {0, 0}, to = {0, 18},
                stops = {{0, "#CC6666"}, {0.5, "#CCCC66"}, {1.0, "#66CC66"} } })
   vicious.register(w, vicious.widgets.cpu, "$" .. i, 3)
   cpu_widgets[i-1] = w
end

vicious.cache(vicious.widgets.mem)
mem_icon = wibox.widget.imagebox()
mem_icon:set_image(config_dir .. "/icons/mem.png")
mem_widget = awful.widget.progressbar()
mem_widget:set_width(8)
mem_widget:set_height(18)
mem_widget:set_vertical(true)
mem_widget:set_background_color("#000000")
mem_widget:set_color({type = "linear", from = {0, 0}, to = {0, 18},
             stops = {{0, "#CC6666"}, {0.5, "#CCCC66"}, {1.0, "#66CC66"} } })
vicious.register(mem_widget, vicious.widgets.mem, "$1", 3)

-- Display notification if low battery
function notify(title, text)
    naughty.notify({ title = title,
                     text = text,
                     height = 50,
                     width = 200,
                     bg = '#B9121B',
                     border_width = 5,
                     border_color = '#FF0000',
                     timeout = 10 })
end

bat_widget = wibox.widget.textbox()
vicious.register(bat_widget, vicious.widgets.bat,
                 function (widget, args)
                    local ret = ""
                    local state = args[1]
                    local pct = args[2]
                    local time = args[3]
                    local colors = {
                       LOW  = "#ac7373", -- red-2
                       low  = "#dfaf8f", -- orange
                       med  = "#f0dfaf", -- yellow
                       high = "#afd8af", -- green+3
                       ok   = "lightblue"
                    }
                    local col
                    if state == "⌁" or state == "↯" then
                       -- Unknown or full
                       ret = markup.fg.color(colors["ok"], pct .. "% " .. state)
		       warnings = false
                    elseif state == "+" then
                       -- Charging
		       warnings = false
                       ret = markup.fg.color(colors["high"], pct .. "% ↗")
                       if time ~= "N/A" then
                          if pct >= 75 then col = "high"
                          elseif pct < 10 then col = "med"
                          else col = "ok" end
                          ret = ret .. markup.fg.color(colors[col], " (" .. time .. ")")
                       end
                    else
                       -- Discharging
                       if pct <= 25 then
			    col = "LOW"
			    if warnings == false then
				notify('Warning', 'Low battery !')
				warnings = true
			    else
				warnings = false
			    end
		       else col = "low"
		       end
                       ret = markup.fg.color(colors[col], pct .. "% ↘")
                       if time ~= "N/A" then
                          if pct <= 25 then col = "LOW"
                          elseif pct <= 50 then col = "low"
                          else col = "ok" end
                          ret = ret .. markup.fg.color(colors[col], " (" .. time .. ")")
                       end
                    end
                    return " " .. ret .. " "
                 end,
                 5, "BAT0")


-- Awesome Default : Create a wibox for each screen and add it--{{{
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))--}}}

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "18", screen = s, ontop = nil })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    local my_right_widgets = _.concat(cpu_icon, cpu_widgets, mem_icon, mem_widget, separator, bat_widget, separator)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    for i, w in pairs(my_right_widgets) do right_layout:add(w) end
    --if s == 1 then right_layout:add(separator) end

    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock_icon)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
--}}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey,       }, "F12", function () awful.util.spawn("/usr/bin/slock") end),
	awful.key({ modkey,	  }, "b", function () awful.util.spawn("chromium --incognito") end),
	awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer sset Master 5%+ unmute > /dev/null") end),
	awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer sset Master 5%- unmute > /dev/null")  end),
	awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer sset Master mute > /dev/null")  end),
	awful.key({ }, "XF86HomePage", function () awful.util.spawn("chromium")  end),
	awful.key({ }, "XF86Mail", function () awful.util.spawn("thunderbird")  end),
	awful.key({ }, "XF86Calculator",function () awful.util.spawn("gnome-calculator")  end),
        awful.key({ modkey,       }, "Left",   awful.tag.viewprev       ),
        awful.key({ modkey,       }, "Right",  awful.tag.viewnext       ),
        awful.key({ modkey,       }, "Escape", awful.tag.history.restore),
        awful.key({ modkey,       }, "j",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),

        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
        awful.key({ modkey, "Control" }, "r", awesome.restart),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
        awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

        awful.key({ modkey, "Control" }, "n", awful.client.restore),

        -- Prompt
        awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run({ prompt = "Run Lua code: " },
                      mypromptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
                  end),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
					 size_hints_honor = false} },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "QNetSoul" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "xchat" },
      properties = { tag = tags[1][9] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
