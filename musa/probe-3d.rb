require 'matrix'
require 'musa-dsl'

class Probe3D
  using Musa::Extension::Matrix

  include Mittsu

  def initialize(axis_length, logger:)
    super()

    @logger = logger

    @scroll_means_move = false
    @scroll_means_zoom = false

    @renderer = OpenGLRenderer.new width: 1024, height: 768, title: 'Matrix Probe'
    @scene = Scene.new

    @camera = PerspectiveCamera.new(75.0, (1024/768r).to_f, 0.1, 1000.0)
    @camera.position.z = 10.0

    axis_colors = [0xff0000, 0x00ff00, 0x0000ff]
    material = axis_colors.collect { |c| LineBasicMaterial.new(color: c) }
    complementary_axis = [1, 0, 0]

    @root = Group.new

    axis_mesh = Mesh.new

    (0..2).each do |axis|
      geometry = Geometry.new

      (0..axis_length-1).each do |position|
        v0 = [0] * 3
        v0[axis] = position

        v1 = [0] * 3
        v1[axis] = position + 1

        v2 = v1.clone
        v2[complementary_axis[axis]] = -0.1

        geometry.vertices << Vector3.new(*v0)
        geometry.vertices << Vector3.new(*v1)
        geometry.vertices << Vector3.new(*v2)
        geometry.vertices << Vector3.new(*v1)
      end

      axis_mesh.add Line.new(geometry, material[axis])
    end

    @root.add(axis_mesh)
    @scene.add(@root)

    @lines = {}
  end

  def run
    @renderer.window.on_scroll do |offset|
      if @scroll_means_move
        @root.position.x += offset.x / 20.0
        @root.position.y -= offset.y / 20.0
      elsif @scroll_means_zoom
        @root.position.z += offset.y / 50.0
      else
        @root.rotation.x -= offset.y / 100.0

        @root.rotation.x = 0.5 if @root.rotation.x > 0.5
        @root.rotation.x = -0.5 if @root.rotation.x < -0.5

        @root.rotation.y -= offset.x / 50.0
      end
    end

    @renderer.window.on_key_pressed do |key|
      case key
      when GLFW_KEY_LEFT_SHIFT, GLFW_KEY_RIGHT_SHIFT
        @scroll_means_move = true
      when GLFW_KEY_LEFT_ALT, GLFW_KEY_RIGHT_ALT
        @scroll_means_zoom = true
      end
    end

    @renderer.window.on_key_released do |key|
      case key
      when GLFW_KEY_LEFT_SHIFT, GLFW_KEY_RIGHT_SHIFT
        @scroll_means_move = false
      when GLFW_KEY_LEFT_ALT, GLFW_KEY_RIGHT_ALT
        @scroll_means_zoom = false
      end
    end

    @renderer.window.run do
      begin
        @renderer.render(@scene, @camera)
      rescue NoMethodError => e
        @logger.error e
      end
    end
  end

  def render_matrix(matrix, color: nil)
    color ||= 0xa0a0a0

    material = LineBasicMaterial.new(color: color)
    mesh = Mesh.new
    geometry = Geometry.new

    matrix._rows.each do |row|
      geometry.vertices << Vector3.new(*row)
    end

    mesh.add Line.new(geometry, material)
    @root.add(mesh)
  end

  def render_point(line_name, point, color: nil)
    line = @lines[line_name]

    if line
      @root.remove line
      new_line = Line.new(nil, line.material)
      new_line.geometry.vertices = line.geometry.vertices
    else
      material = LineBasicMaterial.new(color: color || 0xa0a0a0)
      new_line = @lines[line_name] = Line.new(nil, material)
    end

    new_line.geometry.vertices << Vector3.new(*point)
    # puts "render_point: point #{point}"
    @root.add new_line
  end
end
