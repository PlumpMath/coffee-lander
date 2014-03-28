
class LanderGame
  constructor: (@width, @height) ->
    @game = new Phaser.Game(@width, @height, Phaser.CANVAS, 'main', preload: @preload, create: @create, update: @update, render: @render)

  create: =>
    @game.add.tileSprite(0, 0, 800, 800, "background")
    @game.physics.startSystem(Phaser.Physics.P2JS)
    @game.world.setBounds(0, 0, 800, 800)
    @game.stage.backgroundColor = '#000'
    @background = @game.add.tileSprite(0, 0, 1000, 900, "background")

    @bmd = @game.add.bitmapData(800, 600)
    @bmd.context.fillStyle = '#ffffff'

    @bg = @game.add.sprite(0, 0, @bmd)

    @game.physics.p2.gravity.y = 80
    @game.physics.p2.defaultRestitution = 0.8

    @sprite = window.s = @game.add.sprite(32, 450, 'lander')
    @resetLander()

    # @game.camera.follow(@sprite, Phaser.Camera.FOLLOW_LOCKON);
    @game.physics.p2.enable(@sprite)

  resetLander: =>
    @sprite.position.x = 400
    @sprite.position.y = 400

  update: =>
    @updateAngle()
    @updateForces()
    # @stopOnEdges()

  # stopOnEdges: =>


  updateForces: =>
    forces = @getForces()
    # console.log " X = #{forces[0]}       Y = #{forces[1]} "
    @sprite.body.force.destination[0] = forces[0]
    @sprite.body.force.destination[1] = forces[1]

  getForces: =>
    return [0, 0] unless @isDown('up')

    thrust = 8
    rotation = @sprite.body.rotation

    return [
      -thrust * Math.sin(rotation),
      # thrust / 4
      thrust * Math.cos(rotation)
    ]

    # radians_in_full_circle = 2 * Math.PI
    # degrees_per_radian = 360 / radians_in_full_circle
    # angle_in_radians = @sprite.body.angle / degrees_per_radian
    # angle = @sprite.body.angle / Math.PI / 2

    # return [0, thrust] if angle_in_radians == 0

    # console.log angle_in_radians
    # forceX = -thrust * Math.cos(angle_in_radians)
    # forceX = 0
    # forceY = thrust * Math.sin(angle_in_radians)
    # forceY = 3

    # forceY = - (thrust * Math.sin(angle_in_radians))
    # forceX = forceY / Math.(angle_in_radians)
    # forceX = 0

    # [forceX, forceY]


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
    @game.load.image("background", "img/moonsurface.png")
    # @game.load.image("background", "img/space01.png")

game = new LanderGame 1600, 1000
console.log document.getElementById('reset-lander').click -> alert 'omg'

