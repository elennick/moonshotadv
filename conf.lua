function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.version = "11.3"
    t.window.resizable = false
    t.window.vsync = true
    t.window.fullscreen = false
    t.window.msaa = 1
    t.window.title = "Super Moonshot Adventure"
    t.console = true
    t.modules.joystick = false
    t.modules.physics = true
    t.modules.mouse = false

    t.releases = {
        title = 'Super Moonshot Adventure', -- The project title (string)
        package = nil, -- The project command and package name (string)
        loveVersion = '11.3', -- The project LÖVE version
        version = '1.0', -- The project version
        author = 'Evan Lennick', -- Your name (string)
        email = 'elennick@gmail.com', -- Your email (string)
        description = nil, -- The project description (string)
        homepage = 'https://elennick.itch.io/httpselennickitchiosuper-moonshot-adventure', -- The project homepage (string)
        identifier = 'com.evanlennick.sma', -- The project Uniform Type Identifier (string)
        excludeFileList = {}, -- File patterns to exclude. (string list)
        releaseDirectory = 'releases', -- Where to store the project releases (string)
    }
end
