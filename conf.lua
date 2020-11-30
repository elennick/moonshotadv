function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.version = "11.3"
    t.window.resizable = false
    t.window.vsync = false
    t.window.fullscreen = false
    t.window.msaa = 1
    t.window.title = "Super Moonshot Adventure"

    t.console = true

    t.modules.joystick = false
    t.modules.physics = true
    t.modules.mouse = false
end
