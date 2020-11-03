function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.version = "11.3"
    t.window.resizable = false
    t.window.vsync = true
    t.window.fullscreen = false
    t.window.msaa = 1
    t.window.title = "BKs Super Moonshot Adventure"

    t.console = true

    t.modules.joystick = false
    t.modules.physics = false
    t.modules.mouse = false
end
