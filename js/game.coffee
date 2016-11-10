config = Config.get()
config.fillWindow()
config.toggleStats()

engine = new Engine3D()

Engine3D.scenify(engine, ->
  Utils.console()
  Helper.orbitControls(engine)
)

engine.render()
