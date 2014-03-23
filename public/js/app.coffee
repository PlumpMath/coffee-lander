
class LanderGame
  constructor: ->
    @game = new Phaser.Game(800, 500, Phaser.CANVAS, 'main', preload: @preload, create: @create, update: @update, render: @render)

  create: =>
    @game.add.tileSprite(0, 0, 1000, 900, "background")
    @game.physics.startSystem(Phaser.Physics.P2JS)
    @game.world.setBounds(0, 0, 800, 2000)
    @game.stage.backgroundColor = '#000'
    @background = @game.add.tileSprite(0, 0, 1000, 900, "background")

    @bmd = @game.add.bitmapData(800, 600)
    @bmd.context.fillStyle = '#ffffff'

    @bg = @game.add.sprite(0, 0, @bmd)

    @game.physics.p2.gravity.y = 3
    @game.physics.p2.defaultRestitution = 0.8

    @sprite = @game.add.sprite(32, 450, 'lander')
    @sprite.x = 400
    @sprite.y = 400
    @sprite.anchor.x = 64
    @sprite.anchor.y = 180
    @sprite.fixedRotation = true
    @game.camera.follow(@sprite, Phaser.Camera.FOLLOW_LOCKON);
    @game.physics.p2.enable(@sprite)

  update: =>
    angleDelta = 1
    rotationDirection = 0

    if (@game.input.keyboard.isDown(Phaser.Keyboard.LEFT))
      rotationDirection = -1
    if (@game.input.keyboard.isDown(Phaser.Keyboard.RIGHT))
      rotationDirection = 1

    @sprite.body.angle+= angleDelta * rotationDirection

  render: =>
  preload: =>
    @game.load.image('lander', 'img/lander.png')
    @game.load.image("background", "img/space01.png")

new LanderGame
