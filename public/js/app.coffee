
class LanderGame
  options:
    width: 900
    height: 600
    gravity: 150
    thrust: 30
    rotationSpeed: 2

  texts: {}

  constructor: (options) ->
    jQuery.extend @options, options

    @game = new Phaser.Game(@options.width, @options.height, Phaser.WEBGL, 'main', preload: @preload, create: @create, update: @update, render: @render)

  create: =>
    @game.add.tileSprite(0, 0, 800, 800, "background")
    @game.physics.startSystem(Phaser.Physics.P2JS)
    @game.world.setBounds(0, 0, 800, 800)
    @game.stage.backgroundColor = '#000'
    @background = @game.add.tileSprite(0, 0, 1000, 900, "background")

    @bmd = @game.add.bitmapData(800, 600)
    @bmd.context.fillStyle = '#ffffff'

    @bg = @game.add.sprite(0, 0, @bmd)

    @game.physics.p2.defaultRestitution = 0.8

    @sprite = window.s = @game.add.sprite(32, 450, 'lander')

    # @game.camera.follow(@sprite, Phaser.Camera.FOLLOW_LOCKON);
    @game.physics.p2.enable(@sprite)

    @resetGame()

  updateFromOptions: =>
    game.game.physics.p2.gravity.y = @options.gravity

  resetGame: =>
    @sprite.body.x = @options.width / 2
    @sprite.body.y = @options.height / 10
    @sprite.body.rotation = 0
    @sprite.body.force.destination[0] = 0
    @sprite.body.force.destination[1] = 0
    @sprite.body.velocity.destination[0] = 0
    @sprite.body.velocity.destination[1] = 0
    @hideFailMessage()

  afterUpdate: (game) ->

  update: =>
    @updateFromOptions()
    @updateAngle()
    @updateForces()
    @failOnEdges()
    @afterUpdate(@)

  failOnEdges: =>
    x = @sprite.body.x
    y = @sprite.body.y

    if x < 0 || x > @options.width || y < 0 || y > @options.height
      @showFailMessage()
      setTimeout @resetGame, 2000

  showFailMessage: =>
    unless @text
      @text = @game.add.text(@game.world.centerX, @game.world.centerY, "faaaail")
      @text.anchor.set(0.5)
      @text.align = 'center'
      @text.font = 'Arial'
      @text.fontWeight = 'bold'
      @text.fontSize = 70
      @text.fill = '#ffffff'
      @text.visible = false
      window.t=@text
    @text.visible = true

  hideFailMessage: =>
    @text.visible = false if @text

  updateForces: =>
    forces = @getForces()
    @sprite.body.force.destination[0] = forces[0]
    @sprite.body.force.destination[1] = forces[1]

  getForces: =>
    return [0, 0] unless @isDown('up')

    rotation = @sprite.body.rotation

    return [
      -@options.thrust * Math.sin(rotation),
      @options.thrust * Math.cos(rotation)
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
    rotationDirection = 0

    if (@isDown 'left')
      rotationDirection = -1
    if (@isDown 'right')
      rotationDirection = 1

    @sprite.body.angle+= @options.rotationSpeed * rotationDirection

  keys:
    left: Phaser.Keyboard.LEFT
    right: Phaser.Keyboard.RIGHT
    up: Phaser.Keyboard.UP
    down: Phaser.Keyboard.DOWN

  isDown: (key) =>
    @game.input.keyboard.isDown(@keys[key])

  render: =>
  preload: =>
    # @game.load.image('lander', 'img/lander.png')
    @game.load.image('lander', 'img/pixel-lander.png')
    @game.load.image("background", "img/moonsurface.png")
    # @game.load.image("background", "img/space01.png")

defaultOptions = LanderGame::options
$gravity = $('#gravity').val defaultOptions.gravity
$thrust = $('#thrust').val defaultOptions.thrust
$rotationSpeed = $('#rotation-speed').val defaultOptions.rotationSpeed

game = new LanderGame width: 900, height: 600

$('#reset-lander').on 'click', game.resetGame

['gravity', 'thrust', 'rotationSpeed'].forEach (param) ->
  $el = this['$'+param]
  $el.on 'change', (e) ->
    $el.next('span').text = game.options[param] = $el.val()

# $gravity.on 'change', (e) ->
#   game.options.gravity = $(e.target).val()
#
# $thrust.on 'change', (e) ->
#   game.options.thrust = $(e.target).val()
#
# $rotationSpeed.on 'change', (e) ->
#   game.options.rotationSpeed = $(e.target).val()
