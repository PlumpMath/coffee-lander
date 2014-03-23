
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

    @sprite = window.s = @game.add.sprite(32, 450, 'lander')
    # @sprite.x = 400
    # @sprite.y = 400
    # @sprite.anchor.x = 64
    # @sprite.anchor.y = 180
    @sprite.fixedRotation = true
    @game.camera.follow(@sprite, Phaser.Camera.FOLLOW_LOCKON);
    @game.physics.p2.enable(@sprite)
    # @sprite.body.angle = 33

  update: =>
    @updateAngle()
    @updateForces()

  updateForces: =>
    @sprite.body.force.destination = @getForces()

  getForces: =>
    # sin(angle) = forceY/thrust
    # cos(angle) = forceX/thrust
    # tan(angle) = forceY/forceX

    return [0, 0] unless @isDown('up')

    thrust = 10
    angle = @sprite.body.angle

    return [0, thrust] if angle == 0

    forceY = thrust * Math.sin(angle)
    forceX = forceY / Math.atan(angle)

    [forceX, forceY]


  updateAngle: =>
    angleDelta = 1
    rotationDirection = 0

    if (@isDown 'left')
      rotationDirection = -1
    if (@isDown 'right')
      rotationDirection = 1

    @sprite.body.angle+= angleDelta * rotationDirection

  keys:
    left: Phaser.Keyboard.LEFT
    right: Phaser.Keyboard.RIGHT
    up: Phaser.Keyboard.UP
    down: Phaser.Keyboard.DOWN

  isDown: (key) =>
    @game.input.keyboard.isDown(@keys[key])

  render: =>
  preload: =>
    @game.load.image('lander', 'img/lander.png')
    @game.load.image("background", "img/space01.png")

new LanderGame
